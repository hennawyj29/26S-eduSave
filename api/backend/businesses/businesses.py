
from flask import Blueprint, jsonify, request, current_app
from backend.db_connection import get_db
from mysql.connector import Error

# Create a Blueprint for businesses routes
businesses = Blueprint("businesses", __name__)

# POST /b/discounts - Create a new discount listing
# User stories: [3.3]
@businesses.route("/discounts", methods=["POST"])
def create_discount():
    cursor = get_db().cursor(dictionary=True)
    try:
        data = request.get_json()

        required_fields = ["Discount_Id", "Biz_Id", "Category_Id", "Disc_Title", "Disc_Amount", "Disc_Status", "Created_At", "Promo_Code"]
        for field in required_fields:
            if field not in data:
                return jsonify({"error": f"Missing required field: {field}"}), 400

        query = """
            INSERT INTO Discount (Discount_Id, Biz_Id, Category_Id, Disc_Title, Disc_Amount, Disc_Status, Created_At, Promo_Code)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """
        cursor.execute(query, (
            data["Discount_Id"],
            data["Biz_Id"],
            data["Category_Id"],
            data["Disc_Title"],
            data["Disc_Amount"],
            data["Disc_Status"],
            data["Created_At"],
            data["Promo_Code"]
        ))

        get_db().commit()
        return jsonify({"message": "Discount created successfully", "Discount_Id": cursor.lastrowid}), 201
    except Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

# GET /b/listing-analytics - Return view, and save counts for a business's discounts
# User stories: [3.1]
@businesses.route("/listing-analytics", methods=["GET"])
def get_listing_analytics():
    cursor = get_db().cursor(dictionary=True)
    try:
        current_app.logger.info('GET /b/listing-analytics')

        biz_id = request.args.get("Biz_Id")
        if not biz_id:
            return jsonify({"error": "Biz_Id not found"}), 400

        # Verify the business exists before querying its analytics
        cursor.execute("SELECT Biz_Id FROM Business WHERE Biz_Id = %s", (biz_id,))
        if not cursor.fetchone():
            return jsonify({"error": "Business not found"}), 404

        # Aggregate views, saves, and redemptions per discount listing for this business
        query = """
            SELECT
                la.Analytics_Id,
                la.Disc_Id,
                d.Disc_Title,
                d.Disc_Amount,
                la.View_Count,
                la.Save_Count,
                la.Redemption_Count
            FROM Listing_Analytics la
            JOIN Discount d ON la.Disc_Id = d.Discount_Id
            WHERE d.Biz_Id = %s
            GROUP BY la.Analytics_Id, la.Disc_Id, d.Disc_Title, d.Disc_Amount
        """
        cursor.execute(query, (biz_id,))
        results = cursor.fetchall()

        current_app.logger.info(f'Retrieved analytics for {len(results)} listings for business {biz_id}')
        return jsonify(results), 200
    except Error as e:
        current_app.logger.error(f'Database error in get_listing_analytics: {e}')
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

# GET /b/traffic-snapshots - Return traffic period data for a business, ordered by volume
# User stories: [3.2]
@businesses.route("/traffic-snapshots", methods=["GET"])
def get_traffic_snapshots():
    cursor = get_db().cursor(dictionary=True)
    try:
        current_app.logger.info('GET /b/traffic-snapshots')

        biz_id = request.args.get("Biz_Id")
        if not biz_id:
            return jsonify({"error": "Biz_Id not found"}), 400

        # Verify the business exists before querying its traffic
        cursor.execute("SELECT Biz_Id FROM Business WHERE Biz_Id = %s", (biz_id,))
        if not cursor.fetchone():
            return jsonify({"error": "Business not found"}), 404

        # Return daily traffic volume across all listings for this business, highest volume first
        query = """
            SELECT
                DATE(dv.Viewed_At)    AS Traffic_Date,
                DAYNAME(dv.Viewed_At) AS Day_Of_Week,
                COUNT(dv.View_Id)     AS View_Volume
            FROM Discount_View dv
            JOIN Discount d ON dv.Discount_Id = d.Discount_Id
            WHERE d.Biz_Id = %s
            GROUP BY DATE(dv.Viewed_At), DAYNAME(dv.Viewed_At)
            ORDER BY View_Volume DESC
        """
        cursor.execute(query, (biz_id,))
        results = cursor.fetchall()

        current_app.logger.info(f'Retrieved {len(results)} traffic snapshots for business {biz_id}')
        return jsonify(results), 200
    except Error as e:
        current_app.logger.error(f'Database error in get_traffic_snapshots: {e}')
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

# GET /b/competitor-listings - Return competitor discount for a business
# User stories: [3.6]
@businesses.route("/competitor-listings", methods=["GET"])
def get_competitor_listings():
    cursor = get_db().cursor(dictionary=True)
    try:
        current_app.logger.info('GET /b/competitor-listings')

        biz_id = request.args.get("Biz_Id")
        if not biz_id:
            return jsonify({"error": "Biz_Id not found"}), 400

        # Verify the business exists before querying competitors
        cursor.execute("SELECT Biz_Id FROM Business WHERE Biz_Id = %s", (biz_id,))
        if not cursor.fetchone():
            return jsonify({"error": "Business not found"}), 404

        # Find active discounts from businesses in the same category, excluding the requester
        query = """
            SELECT
                b.Biz_Id,
                b.Biz_Name,
                b.Address,
                d.Discount_Id,
                d.Disc_Title,
                d.Disc_Amount,
                d.Disc_Status,
                d.Created_At
            FROM Discount d
            JOIN Business b ON d.Biz_Id = b.Biz_Id
            WHERE d.Disc_Status = 1
              AND d.Biz_Id != %s
              AND d.Category_Id IN (
                  SELECT DISTINCT Category_Id
                  FROM Discount
                  WHERE Biz_Id = %s
              )
            ORDER BY d.Disc_Amount DESC
        """
        cursor.execute(query, (biz_id, biz_id))
        results = cursor.fetchall()

        current_app.logger.info(f'Retrieved {len(results)} competitor listings for business {biz_id}')
        return jsonify(results), 200
    except Error as e:
        current_app.logger.error(f'Database error in get_competitor_listings: {e}')
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

# PUT /b/businesses/<int:biz_id> - Activate or deactivate a business account
# User stories: [4.5]
@businesses.route("/businesses/<int:biz_id>", methods=["PUT"])
def update_business_status(biz_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        current_app.logger.info(f'PUT /b/businesses/{biz_id}')
        data = request.get_json()

        # Verify the business exists before attempting an update
        cursor.execute("SELECT Biz_Id FROM Business WHERE Biz_Id = %s", (biz_id,))
        if not cursor.fetchone():
            return jsonify({"error": "Business not found"}), 404

        # Build update query dynamically based on provided fields
        allowed_fields = ["Account_Status", "Biz_Name", "Biz_Location"]
        update_fields = [f"{f} = %s" for f in allowed_fields if f in data]
        params = [data[f] for f in allowed_fields if f in data]

        if not update_fields:
            return jsonify({"error": "No valid fields to update"}), 400

        # Validate Account_Status value if it's being updated
        if "Biz_Status" in data and data["Account_Status"] not in ("Active", "Inactive"):
            return jsonify({"error": "Account_Status must be 'Active' or 'Inactive'"}), 400

        params.append(biz_id)
        query = f"UPDATE Business SET {', '.join(update_fields)} WHERE Biz_Id = %s"
        cursor.execute(query, params)
        get_db().commit()

        current_app.logger.info(f'Business {biz_id} updated successfully')
        return jsonify({"message": f"Business {biz_id} updated successfully", "Biz_Id": biz_id}), 200
    except Error as e:
        current_app.logger.error(f'Database error in update_business_status: {e}')
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()