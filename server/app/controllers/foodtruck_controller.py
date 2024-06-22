
from flask import Blueprint, request, jsonify
from app.models.foodtruck import Foodtruck
from app import db

foodtruck_bp = Blueprint('foodtruck_bp', __name__, url_prefix='/foodtruck')

@foodtruck_bp.route('', methods=['GET'])
def get_all_foodtrucks():
    foodtruck = Foodtruck.query.all()
    return jsonify([truck.serialize() for truck in foodtruck]), 200

@foodtruck_bp.route('/<int:foodtruck_id>', methods=['GET'])
def get_foodtruck(foodtruck_id):
    foodtruck = Foodtruck.query.get(foodtruck_id)
    if not foodtruck:
        return jsonify({'error': 'Foodtruck not found'}), 404
    return jsonify(foodtruck.serialize()), 200


@foodtruck_bp.route('', methods=['POST'])
def create_dish():
    data = request.get_json()
    new_foodtruck = Foodtruck(name=data['name'], info=data['info'])
    db.session.add(new_foodtruck)
    db.session.commit()
    return jsonify(new_foodtruck.serialize()), 201
