
from flask import Blueprint, jsonify, request, current_app
from backend.db_connection import get_db
from mysql.connector import Error

# Create a Blueprint for admin routes
admin = Blueprint("admin", __name__)