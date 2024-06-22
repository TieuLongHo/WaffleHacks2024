from app import db

class Foodtruck(db.Model):
    __tablename__ = 'foodtruck'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    info = db.Column(db.String(255), nullable=False)
    longitude = db.Column(db.Float, nullable=False)
    latitude = db.Column(db.Float, nullable=False)
    menu = db.relationship('Dish', back_populates='truck', cascade='all, delete-orphan')

    def serialize(self):
        return {
            'id': self.id,
            'name': self.name,
            'info': self.info,
            'longitude': self.longitude,
            'latitude': self.latitude,
            'menu': [dish.serialize() for dish in self.menu]
        }
