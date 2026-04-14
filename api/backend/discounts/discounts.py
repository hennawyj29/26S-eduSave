
from flask import Blueprint, jsonify, request, current_app
from backend.db_connection import get_db
from mysql.connector import Error

# Create a Blueprint for discounts routes
discounts = Blueprint("discounts", __name__)

# PUT /d/discounts/<int:disc_id> - Update discount amount
# User stories: [3.4]
@discounts.route("/discounts/<int:disc_id>/amount", methods=["PUT"])
def update_discount_amount(disc_id):
    #TO IMPLEMENT (adding in the queries)
    pass

# PUT /d/discounts/<int:disc_id>/status - Deactivate or toggle discount status
# User stories: [3.5], [2.6], [4.3]
@discounts.route("/discounts/<int:disc_id>/status", methods=["PUT"])
def toggle_discount_status(disc_id):
    #TO IMPLEMENT (adding in the queries)
    pass

# PUT /d/discounts/<int:disc_id>/approve - Approve a pending discount
# User stories: [4.2]
@discounts.route("/discounts/<int:disc_id>/approve", methods=["PUT"])
def approve_discount(disc_id):
    #TO IMPLEMENT (adding in the queries)
    pass

# PUT /d/discounts/bulk-deactivate - Bulk-deactivate discounts from unverified businesses
# User stories: [4.1]
@discounts.route("/discounts/bulk-deactivate", methods=["PUT"])
def bulk_deactivate_discounts():
    #TO IMPLEMENT (adding in the queries)
    pass

# DELETE /d/discounts/<int:disc_id> - Delete an inactive discount
# User stories: [4.1]
@discounts.route("/discounts/<int:disc_id>", methods=["DELETE"])
def delete_discount(disc_id):
    #TO IMPLEMENT (adding in the queries)
    pass