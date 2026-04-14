from flask import Blueprint, jsonify, request, current_app
from backend.db_connection import get_db
from mysql.connector import Error

# Create a Blueprint for students routes
students = Blueprint("students", __name__)

# GET /s/discounts - Return all active, verified discounts (filterable by category, location, amount)
# User stories: [1.1], [1.2], [1.4]
@students.route("/discounts", methods=["GET"])
def get_discounts():
    #TO IMPLEMENT (adding in the queries)
    pass

# GET /s/discounts/categories - Return all available categories
# User stories: [1.3]
@students.route("/discounts/categories", methods=["GET"])
def get_categories():
    #TO IMPLEMENT (adding in the queries)
    pass

# POST /s/saved-discounts - Save a discount to a student's list
# User stories: [1.6], [2.2]
@students.route("/saved-discounts", methods=["POST"])
def save_discount():
    #TO IMPLEMENT (adding in the queries)
    pass

# GET /s/saved-discounts/<int:student_id> - Return all discounts saved by a student
# User stories: [1.6]
@students.route("/saved-discounts/<int:student_id>", methods=["GET"])
def get_saved_discounts(student_id):
    #TO IMPLEMENT (adding in the queries)
    pass

# POST /s/shared-discounts - Share a discount with another student
# User stories: [2.5]
@students.route("/shared-discounts", methods=["POST"])
def share_discount():
    #TO IMPLEMENT (adding in the queries)
    pass

# POST /s/notifications - Send a deal alert notification to a student
# User stories: [1.5]
@students.route("/notifications", methods=["POST"])
def send_notification():
    #TO IMPLEMENT (adding in the queries)
    pass