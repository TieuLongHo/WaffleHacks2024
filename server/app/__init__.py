from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from app.config import SQLALCHEMY_DATABASE_URI, SQLALCHEMY_TRACK_MODIFICATIONS

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = SQLALCHEMY_DATABASE_URI
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = SQLALCHEMY_TRACK_MODIFICATIONS

db = SQLAlchemy(app)

from app.models.dish import Dish
from app.models.foodtruck import Foodtruck

from app.controllers.dish_controller import dish_bp
from app.controllers.foodtruck_controller import foodtruck_bp

app.register_blueprint(dish_bp)
app.register_blueprint(foodtruck_bp)
