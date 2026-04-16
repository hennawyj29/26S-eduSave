
from flask import Blueprint, jsonify, request, current_app
from backend.db_connection import get_db
from mysql.connector import Error

# Create a Blueprint for admin routes
admin = Blueprint("admin", __name__)

# GET /a/discounts - Return all pending/inactive discounts for review
# User stories: [4.2]
@admin.route("/discounts", methods=["GET"])
def get_pending_discounts():
    cursor = get_db().cursor(dictionary=True)
    try:
        current_app.logger.info('GET /a/discounts')

        cursor.execute("SELECT * FROM Discount WHERE Disc_Status = 0")
        discounts = cursor.fetchall()

        current_app.logger.info(f'Retrieved {len(discounts)} pending discounts')
        return jsonify(discounts), 200
    except Error as e:
        current_app.logger.error(f'Database error in get_pending_discounts: {e}')
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()


# GET /a/reports - Return reports assigned to admin, ordered by priority
# User stories: [4.4]
@admin.route("/reports", methods=["GET"])
def get_reports():
    cursor = get_db().cursor(dictionary=True)
    try:
        current_app.logger.info('GET /a/reports')

        cursor.execute("SELECT * FROM Report ORDER BY Priority DESC")
        reports = cursor.fetchall()

        current_app.logger.info(f'Retrieved {len(reports)} reports')
        return jsonify(reports), 200
    except Error as e:
        current_app.logger.error(f'Database error in get_reports: {e}')
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
    

# GET /a/platform-metrics - Return snapshot stats from accross the platform
# User stories: [4.6]
@admin.route("/platform-metrics", methods=["GET"])
def get_platform_metrics():
    cursor = get_db().cursor(dictionary=True)
    try:
        current_app.logger.info('GET /a/platform-metrics')

        cursor.execute("SELECT COUNT(*) AS total_users FROM Student")
        total_users = cursor.fetchone()["total_users"]

        cursor.execute("SELECT COUNT(*) AS active_discounts FROM Discount WHERE Disc_Status = 1")
        active_discounts = cursor.fetchone()["active_discounts"]

        cursor.execute("SELECT COUNT(*) AS pending_reports FROM Report WHERE Resolution IS NULL")
        pending_reports = cursor.fetchone()["pending_reports"]

        metrics = {
            "total_users": total_users,
            "active_discounts": active_discounts,
            "pending_reports": pending_reports
        }

        return jsonify(metrics), 200
    except Error as e:
        current_app.logger.error(f'Database error in get_platform_metrics: {e}')
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
    

# PUT /a/businesses/<int:biz_id>/status - Activate or deactivate a business account
# User stories: [4.5]
@admin.route("/businesses/<int:biz_id>/status", methods=["PUT"])
def update_business_status(biz_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        current_app.logger.info(f'PUT /a/businesses/{biz_id}/status')
        data = request.get_json()

        cursor.execute("SELECT Biz_Id FROM Business WHERE Biz_Id = %s", (biz_id,))
        if not cursor.fetchone():
            return jsonify({"error": "Business not found"}), 404

        if "Account_Status" not in data:
            return jsonify({"error": "Missing required field: Account_Status"}), 400

        cursor.execute(
            "UPDATE Business SET Account_Status = %s WHERE Biz_Id = %s",
            (data["Account_Status"], biz_id)
        )
        get_db().commit()

        return jsonify({"message": "Business status updated successfully"}), 200
    except Error as e:
        current_app.logger.error(f'Database error in update_business_status: {e}')
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()


# DELETE /a/discounts/<int:disc_id> - Delete an inactive discount
# User stories: [4.1]
@admin.route("/discounts/<int:disc_id>", methods=["DELETE"])
def delete_discount(disc_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        current_app.logger.info(f'DELETE /a/discounts/{disc_id}')

        cursor.execute("SELECT Discount_Id FROM Discount WHERE Discount_Id = %s", (disc_id,))
        if not cursor.fetchone():
            return jsonify({"error": "Discount not found"}), 404

        cursor.execute("DELETE FROM Discount WHERE Discount_Id = %s", (disc_id,))
        get_db().commit()

        return jsonify({"message": "Discount deleted successfully"}), 200
    except Error as e:
        current_app.logger.error(f'Database error in delete_discount: {e}')
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()