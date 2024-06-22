from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from app.config import SQLALCHEMY_DATABASE_URI, SQLALCHEMY_TRACK_MODIFICATIONS
from flask_cors import CORS


app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "http://localhost:5173"}})
app.config["SQLALCHEMY_DATABASE_URI"] = SQLALCHEMY_DATABASE_URI
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = SQLALCHEMY_TRACK_MODIFICATIONS

db = SQLAlchemy(app)

from app.models.dish import Dish
from app.models.foodtruck import Foodtruck
from app.models.event import Event
from app.models.location import Location

from app.controllers.dish_controller import dish_bp
from app.controllers.foodtruck_controller import foodtruck_bp
from app.controllers.event_controller import event_bp
from app.controllers.location_controller import location_bp

app.register_blueprint(dish_bp)
app.register_blueprint(foodtruck_bp)
app.register_blueprint(event_bp)
app.register_blueprint(location_bp)
