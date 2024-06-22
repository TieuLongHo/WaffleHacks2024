from flask import Blueprint, request, jsonify
from app.models.event import Event
from app import db

event_bp = Blueprint('event_bp', __name__, url_prefix='/event')

@event_bp.route('', methods=['GET'])
def get_all_events():
    events = Event.query.all()
    return jsonify([event.serialize() for event in events])

@event_bp.route('/<int:event_id>', methods=['GET'])
def get_event(event_id):
    dish = Event.query.get(event_id)
    return jsonify(dish.serialize())

@event_bp.route('', methods=['POST'])
def create_event():
    data = request.get_json()
    new_event = Event(name=data['name'], start_date=data['start_date'], end_date=data['end_date'])
    db.session.add(new_event)
    db.session.commit()
    return jsonify(new_event.serialize()), 201
