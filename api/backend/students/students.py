from flask import Blueprint, jsonify, request, current_app
from backend.db_connection import get_db
from mysql.connector import Error

# Create a Blueprint for students routes
students = Blueprint("students", __name__)

# GET /s/discounts - Return all active, verified discounts (filterable by category, location, amount)
# User stories: [1.1], [1.2], [1.4]
@students.route("/discounts", methods=["GET"])
def get_discounts():
    cursor = get_db().cursor(dictionary=True)
    try:
        current_app.logger.info('GET /s/discounts')

        category_id = request.args.get("category_id")
        max_amount = request.args.get("max_amount")
        city = request.args.get("city")

        query = """
            SELECT d.Discount_Id, d.Disc_Title, d.Disc_Amount, d.Promo_Code,
                d.Created_At, c.Category_Name, b.Biz_Name, b.Address, b.Biz_Lat, b.Biz_Lng
            FROM Discount d
            JOIN Business b ON d.Biz_Id = b.Biz_Id
            JOIN Category c ON d.Category_Id = c.Category_Id
            WHERE d.Disc_Status = 1
                AND b.Verified_Status = 1
                AND b.Account_Status = 1
        """
        params = []

        if category_id:
            query += " AND d.Category_Id = %s"
            params.append(category_id)
        if max_amount:
            query += " AND d.Disc_Amount <= %s"
            params.append(max_amount)
        if city:
            query += " AND b.Address LIKE %s"
            params.append(f"%{city}%")

        cursor.execute(query, params)
        discounts = cursor.fetchall()

        current_app.logger.info(f'Retrieved {len(discounts)} discounts')
        return jsonify(discounts), 200
    except Error as e:
        current_app.logger.error(f'Database error in get_discounts: {e}')
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

# GET /s/discounts/categories - Return all available categories
# User stories: [1.3]
@students.route("/discounts/categories", methods=["GET"])
def get_categories():
    cursor = get_db().cursor(dictionary=True)
    try:
        current_app.logger.info('GET /s/discounts/categories')

        cursor.execute("SELECT * FROM Category ORDER BY Category_Name")
        categories = cursor.fetchall()

        return jsonify(categories), 200
    except Error as e:
        current_app.logger.error(f'Database error in get_categories: {e}')
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

# POST /s/saved-discounts - Save a discount to a student's list
# User stories: [1.6], [2.2]
@students.route("/saved-discounts", methods=["POST"])
def save_discount():
    cursor = get_db().cursor(dictionary=True)
    try:
        current_app.logger.info('POST /s/saved-discounts')
        data = request.get_json()

        required_fields = ["Student_Id", "Discount_Id"]
        for field in required_fields:
            if field not in data:
                return jsonify({"error": f"Missing required field: {field}"}), 400

        # Check if already saved
        cursor.execute("""
            SELECT Saved_Id FROM Saved_Discount
            WHERE Student_Id = %s AND Discount_Id = %s
        """, (data["Student_Id"], data["Discount_Id"]))
        if cursor.fetchone():
            return jsonify({"error": "Discount already saved"}), 409

        cursor.execute("""
            INSERT INTO Saved_Discount (Student_Id, Discount_Id, Saved_At)
            VALUES (%s, %s, NOW())
        """, (data["Student_Id"], data["Discount_Id"]))

        get_db().commit()
        return jsonify({"message": "Discount saved successfully", "saved_id": cursor.lastrowid}), 201
    except Error as e:
        current_app.logger.error(f'Database error in save_discount: {e}')
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

# GET /s/saved-discounts/<int:student_id> - Return all discounts saved by a student
# User stories: [1.6]
@students.route("/saved-discounts/<int:student_id>", methods=["GET"])
def get_saved_discounts(student_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        current_app.logger.info(f'GET /s/saved-discounts/{student_id}')

        # Check student exists
        cursor.execute("SELECT Student_Id FROM Student WHERE Student_Id = %s", (student_id,))
        if not cursor.fetchone():
            return jsonify({"error": "Student not found"}), 404

        cursor.execute("""
            SELECT sd.Saved_Id, sd.Saved_At,
                d.Discount_Id, d.Disc_Title, d.Disc_Amount, d.Promo_Code,
                b.Biz_Name, c.Category_Name
            FROM Saved_Discount sd
            JOIN Discount d ON sd.Discount_Id = d.Discount_Id
            JOIN Business b ON d.Biz_Id = b.Biz_Id
            JOIN Category c ON d.Category_Id = c.Category_Id
            WHERE sd.Student_Id = %s
            ORDER BY sd.Saved_At DESC
        """, (student_id,))

        saved = cursor.fetchall()
        return jsonify(saved), 200
    except Error as e:
        current_app.logger.error(f'Database error in get_saved_discounts: {e}')
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

# POST /s/shared-discounts - Share a discount with another student
# User stories: [2.5]
@students.route("/shared-discounts", methods=["POST"])
def share_discount():
    cursor = get_db().cursor(dictionary=True)
    try:
        current_app.logger.info('POST /s/shared-discounts')
        data = request.get_json()

        required_fields = ["Sender_Id", "Reciever_Id", "Discount_Id"]
        for field in required_fields:
            if field not in data:
                return jsonify({"error": f"Missing required field: {field}"}), 400

        # Check sender and receiver are not the same
        if data["Sender_Id"] == data["Reciever_Id"]:
            return jsonify({"error": "Cannot share a discount with yourself"}), 400

        cursor.execute("""
            INSERT INTO Shared_Discount (Sender_Id, Reciever_Id, Discount_Id, Saved_At)
            VALUES (%s, %s, %s, NOW())
        """, (data["Sender_Id"], data["Reciever_Id"], data["Discount_Id"]))

        get_db().commit()
        return jsonify({"message": "Discount shared successfully", "share_id": cursor.lastrowid}), 201
    except Error as e:
        current_app.logger.error(f'Database error in share_discount: {e}')
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

# POST /s/notifications - Send a deal alert notification to a student
# User stories: [1.5]
@students.route("/notifications", methods=["POST"])
def send_notification():
    cursor = get_db().cursor(dictionary=True)
    try:
        current_app.logger.info('POST /s/notifications')
        data = request.get_json()

        required_fields = ["Student_Id", "Notif_Type", "Notif_Msg"]
        for field in required_fields:
            if field not in data:
                return jsonify({"error": f"Missing required field: {field}"}), 400

        # Check student exists
        cursor.execute("SELECT Student_Id FROM Student WHERE Student_Id = %s", (data["Student_Id"],))
        if not cursor.fetchone():
            return jsonify({"error": "Student not found"}), 404

        cursor.execute("""
            INSERT INTO Notification (Student_Id, Notif_Type, Notif_Msg, Sent_Date)
            VALUES (%s, %s, %s, NOW())
        """, (data["Student_Id"], data["Notif_Type"], data["Notif_Msg"]))

        get_db().commit()
        return jsonify({"message": "Notification sent successfully", "notif_id": cursor.lastrowid}), 201
    except Error as e:
        current_app.logger.error(f'Database error in send_notification: {e}')
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()


# GET /s/universities - Return all universities with coordinates 
# User stories: [2.1]
@students.route("/universities", methods=["GET"])
def get_universities():
    cursor = get_db().cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT Uni_Id, Uni_Name, Uni_Lat, Uni_Lng
            FROM University
            WHERE Uni_Lat IS NOT NULL AND Uni_Lng IS NOT NULL
            ORDER BY Uni_Name
        """)
        return jsonify(cursor.fetchall()), 200
    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()