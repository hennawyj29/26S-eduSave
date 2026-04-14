
from flask import Blueprint, jsonify, request, current_app
from backend.db_connection import get_db
from mysql.connector import Error

# Create a Blueprint for admin routes
admin = Blueprint("admin", __name__)

# GET /a/discounts - Return all pending/inactive discounts for review
# User stories: [4.2]
@admin.route("/discounts", methods=["GET"])
def get_pending_discounts():
    #TO IMPLEMENT (adding in the queries)
    pass

# GET /a/reports - Return reports assigned to admin, ordered by priority
# User stories: [4.4]
@admin.route("/reports", methods=["GET"])
def get_reports():
    #TO IMPLEMENT (adding in the queries)
    pass

# GET /a/platform-metrics - Return snapshot stats from accross the platform
# User stories: [4.6]
@admin.route("/platform-metrics", methods=["GET"])
def get_platform_metrics():
    #TO IMPLEMENT (adding in the queries)
    pass

# PUT /a/businesses/<int:biz_id>/status - Activate or deactivate a business account
# User stories: [4.5]
@admin.route("/businesses/<int:biz_id>/status", methods=["PUT"])
def update_business_status(biz_id):
    #TO IMPLEMENT (adding in the queries)
    pass

# DELETE /a/discounts/<int:disc_id> - Delete an inactive discount
# User stories: [4.1]
@admin.route("/discounts/<int:disc_id>", methods=["DELETE"])
def delete_discount(disc_id):
    #TO IMPLEMENT (adding in the queries)
    pass