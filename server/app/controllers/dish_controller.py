from flask import Blueprint, request, jsonify
from app.models.dish import Dish

dish_bp = Blueprint('dish_bp', __name__, url_prefix='/dish')

@dish_bp.route('', methods=['GET'])
def get_all_dishes():
    dishes = Dish.query.all()
    return jsonify([dish.serialize() for dish in dishes])

