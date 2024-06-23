from flask import Blueprint, request, jsonify
from app.models.dish import Dish
from app import db

dish_bp = Blueprint("dish_bp", __name__, url_prefix="/dish")


@dish_bp.route("", methods=["GET"])
def get_all_dishes():
    dishes = Dish.query.all()
    return jsonify([dish.serialize() for dish in dishes])


@dish_bp.route("/<int:dish_id>", methods=["GET"])
def get_dish(dish_id):
    dish = Dish.query.get_or_404(dish_id)
    return jsonify(dish.serialize())


@dish_bp.route("", methods=["POST"])
def create_dish():
    data = request.get_json()
    new_dish = Dish(
        name=data["name"],
        price=data["price"],
        truck_id=data["truck_id"],
        ingredients=data.get("ingredients", []),
    )
    db.session.add(new_dish)
    db.session.commit()
    return jsonify(new_dish.serialize()), 201


@dish_bp.route("/<int:dish_id>", methods=["PUT"])
def update_dish(dish_id):
    data = request.get_json()
    dish = Dish.query.get_or_404(dish_id)
    dish.name = data.get("name", dish.name)
    dish.price = data.get("price", dish.price)
    dish.ingredients = data.get("ingredients", dish.ingredients)
    db.session.commit()
    return jsonify(dish.serialize())


@dish_bp.route("/<int:dish_id>", methods=["DELETE"])
def delete_dish(dish_id):
    dish = Dish.query.get_or_404(dish_id)
    db.session.delete(dish)
    db.session.commit()
    return "", 204
