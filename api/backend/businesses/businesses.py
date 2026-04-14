
from flask import Blueprint, jsonify, request, current_app
from backend.db_connection import get_db
from mysql.connector import Error

# Create a Blueprint for businesses routes
businesses = Blueprint("businesses", __name__)

# POST /b/discounts - Create a new discount listing
# User stories: [3.3]
@businesses.route("/discounts", methods=["POST"])
def create_discount():
    #TO IMPLEMENT (adding in the queries)
    pass

# GET /b/listing-analytics - Return view, and save counts for a business's discounts
# User stories: [3.1]
@businesses.route("/listing-analytics", methods=["GET"])
def get_listing_analytics():
    #TO IMPLEMENT (adding in the queries)
    pass

# GET /b/traffic-snapshots - Return traffic period data for a business, ordered by volume
# User stories: [3.2]
@businesses.route("/traffic-snapshots", methods=["GET"])
def get_traffic_snapshots():
    #TO IMPLEMENT (adding in the queries)
    pass

# GET /b/competitor-listings - Return competitor discount for a business
# User stories: [3.6]
@businesses.route("/competitor-listings", methods=["GET"])
def get_competitor_listings():
    #TO IMPLEMENT (adding in the queries)
    pass

# PUT /b/businesses/<int:biz_id> - Activate or deactivate a business account
# User stories: [4.5]
@businesses.route("/businesses/<int:biz_id>", methods=["PUT"])
def update_business_status(biz_id):
    #TO IMPLEMENT (adding in the queries)
    pass