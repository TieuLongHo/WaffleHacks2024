
from flask import Blueprint, request, jsonify
from app.models.foodtruck import Foodtruck
from app import db

foodtruck_bp = Blueprint('foodtruck_bp', __name__, url_prefix='/foodtrucks')

@foodtruck_bp.route('', methods=['GET'])
def get_foodtrucks():
    foodtruck = FoodTruck.query.all()
    return jsonify([truck.serialize() for truck in foodtruck]), 200
