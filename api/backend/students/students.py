from flask import Blueprint, jsonify, request, current_app
from backend.db_connection import get_db
from mysql.connector import Error

# Create a Blueprint for students routes
students = Blueprint("students", __name__)
