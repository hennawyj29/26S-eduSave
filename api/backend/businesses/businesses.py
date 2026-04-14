
from flask import Blueprint, jsonify, request, current_app
from backend.db_connection import get_db
from mysql.connector import Error

# Create a Blueprint for businesses routes
businesses = Blueprint("businesses", __name__)