from flask import Blueprint, request, jsonify
from app.models.location import Location
from app import db

location_bp = Blueprint("location_bp", __name__, url_prefix="/location")


@location_bp.route("", methods=["GET"])
def get_all_locations():
    locations = Location.query.all()
    return jsonify([location.serialize() for location in locations])


@location_bp.route("/<int:location_id>", methods=["GET"])
def get_location(location_id):
    location = Location.query.get_or_404(location_id)
    return jsonify(location.serialize())


@location_bp.route("", methods=["POST"])
def create_location():
    data = request.get_json()
    new_location = Location(
        longitude=data["longitude"],
        latitude=data["latitude"],
        foodtruck_id=data["foodtruck_id"],
        event_id=data["event_id"],
    )
    db.session.add(new_location)
    db.session.commit()
    return jsonify(new_location.serialize()), 201
