from flask import Blueprint, request, jsonify
from app.models.dish import Dish
from app import db

dish_bp = Blueprint('dish_bp', __name__, url_prefix='/dish')

@dish_bp.route('', methods=['GET'])
def get_all_dishes():
    dishes = Dish.query.all()
    return jsonify([dish.serialize() for dish in dishes])

@dish_bp.route('/<int:dish_id>', methods=['GET'])
def get_dish(dish_id):
    dish = Dish.query.get(dish_id)
    return jsonify(dish.serialize())

@dish_bp.route('', methods=['POST'])
def create_dish():
    data = request.get_json()
    new_dish = Dish(name=data['name'], price=data['price'], truck_id=data['truck_id'])
    db.session.add(new_dish)
    db.session.commit()
    return jsonify(new_dish.serialize()), 201
