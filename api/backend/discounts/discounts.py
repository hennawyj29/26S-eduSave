
from flask import Blueprint, jsonify, request, current_app
from backend.db_connection import get_db
from mysql.connector import Error

# Create a Blueprint for discounts routes
discounts = Blueprint("discounts", __name__)

# PUT /d/discounts/<int:disc_id>/amount - Update discount amount
# User stories: [3.4]
@discounts.route("/discounts/<int:disc_id>/amount", methods=["PUT"])
def update_discount_amount(disc_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        current_app.logger.info(f'PUT /d/discounts/{disc_id}/amount')
        data = request.get_json()

        # Check discount exists
        cursor.execute("SELECT Discount_Id FROM Discount WHERE Discount_Id = %s", (disc_id,))
        if not cursor.fetchone():
            return jsonify({"error": "Discount not found"}), 404

        if "Disc_Amount" not in data:
            return jsonify({"error": "Missing required field: Disc_Amount"}), 400

        cursor.execute(
            "UPDATE Discount SET Disc_Amount = %s WHERE Discount_Id = %s",
            (data["Disc_Amount"], disc_id)
        )
        get_db().commit()

        return jsonify({"message": "Discount amount updated successfully", "Discount_Id": disc_id}), 200
    except Error as e:
        current_app.logger.error(f'Database error in update_discount_amount: {e}')
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

# PUT /d/discounts/<int:disc_id>/status - Deactivate or toggle discount status
# User stories: [3.5], [2.6], [4.3]
@discounts.route("/discounts/<int:disc_id>/status", methods=["PUT"])
def toggle_discount_status(disc_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        current_app.logger.info(f'PUT /d/discounts/{disc_id}/status')

        # Check discount exists and get current status
        cursor.execute("SELECT Disc_Status FROM Discount WHERE Discount_Id = %s", (disc_id,))
        discount = cursor.fetchone()
        if not discount:
            return jsonify({"error": "Discount not found"}), 404

        # Toggle: 1 becomes 0, 0 becomes 1
        new_status = 1 - discount["Disc_Status"]

        cursor.execute(
            "UPDATE Discount SET Disc_Status = %s WHERE Discount_Id = %s",
            (new_status, disc_id)
        )
        get_db().commit()

        status_label = "active" if new_status == 1 else "inactive"
        return jsonify({
            "message": f"Discount status toggled to {status_label}",
            "Discount_Id": disc_id,
            "Disc_Status": new_status
        }), 200
    except Error as e:
        current_app.logger.error(f'Database error in toggle_discount_status: {e}')
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

# PUT /d/discounts/<int:disc_id>/approve - Approve a pending discount
# User stories: [4.2]
@discounts.route("/discounts/<int:disc_id>/approve", methods=["PUT"])
def approve_discount(disc_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        current_app.logger.info(f'PUT /d/discounts/{disc_id}/approve')

        # Check discount exists
        cursor.execute("SELECT Disc_Status FROM Discount WHERE Discount_Id = %s", (disc_id,))
        discount = cursor.fetchone()
        if not discount:
            return jsonify({"error": "Discount not found"}), 404

        # Only approve if currently inactive/pending (status = 0)
        if discount["Disc_Status"] == 1:
            return jsonify({"error": "Discount is already active"}), 400

        cursor.execute(
            "UPDATE Discount SET Disc_Status = 1 WHERE Discount_Id = %s",
            (disc_id,)
        )
        get_db().commit()

        return jsonify({"message": "Discount approved successfully", "Discount_Id": disc_id}), 200
    except Error as e:
        current_app.logger.error(f'Database error in approve_discount: {e}')
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

# PUT /d/discounts/bulk-deactivate - Bulk-deactivate discounts from unverified businesses
# User stories: [4.1]
@discounts.route("/discounts/bulk-deactivate", methods=["PUT"])
def bulk_deactivate_discounts():
    cursor = get_db().cursor(dictionary=True)
    try:
        current_app.logger.info('PUT /d/discounts/bulk-deactivate')

        # Deactivate all discounts belonging to unverified businesses
        cursor.execute("""
            UPDATE Discount d
            JOIN Business b ON d.Biz_Id = b.Biz_Id
            SET d.Disc_Status = 0
            WHERE b.Verified_Status = 0
              AND d.Disc_Status = 1
        """)
        rows_affected = cursor.rowcount
        get_db().commit()

        current_app.logger.info(f'Bulk-deactivated {rows_affected} discounts from unverified businesses')
        return jsonify({
            "message": f"Deactivated {rows_affected} discounts from unverified businesses",
            "rows_affected": rows_affected
        }), 200
    except Error as e:
        current_app.logger.error(f'Database error in bulk_deactivate_discounts: {e}')
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()

# DELETE /d/discounts/<int:disc_id> - Delete an inactive discount
# User stories: [4.1]
@discounts.route("/discounts/<int:disc_id>", methods=["DELETE"])
def delete_discount(disc_id):
    cursor = get_db().cursor(dictionary=True)
    try:
        current_app.logger.info(f'DELETE /d/discounts/{disc_id}')

        # Check discount exists and is inactive before deleting
        cursor.execute("SELECT Disc_Status FROM Discount WHERE Discount_Id = %s", (disc_id,))
        discount = cursor.fetchone()
        if not discount:
            return jsonify({"error": "Discount not found"}), 404

        if discount["Disc_Status"] == 1:
            return jsonify({"error": "Cannot delete an active discount. Deactivate it first."}), 400

        # Remove any saved/shared references before deleting the discount
        cursor.execute("DELETE FROM Saved_Discount WHERE Discount_Id = %s", (disc_id,))
        cursor.execute("DELETE FROM Shared_Discount WHERE Discount_Id = %s", (disc_id,))
        cursor.execute("DELETE FROM Report WHERE Discount_Id = %s", (disc_id,))
        cursor.execute("DELETE FROM Listing_Analytics WHERE Disc_Id = %s", (disc_id,))
        cursor.execute("DELETE FROM Discount WHERE Discount_Id = %s", (disc_id,))
        get_db().commit()

        return jsonify({"message": "Discount deleted successfully", "Discount_Id": disc_id}), 200
    except Error as e:
        current_app.logger.error(f'Database error in delete_discount: {e}')
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
