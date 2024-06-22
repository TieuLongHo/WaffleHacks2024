from app import db

class Dish(db.Model):
    __tablename__ = 'dish'
    id = db.Column(db.Integer, primary_key=True)
    truck_id = db.Column(db.Integer, db.ForeignKey('foodtruck.id', ondelete='CASCADE'), nullable=False)
    name = db.Column(db.String(100), nullable=False)
    price = db.Column(db.Float, nullable=False)
    truck = db.relationship('Foodtruck', back_populates='menu')

    def serialize(self):
        return {
            'id': self.id,
            'truck_id': self.truck_id,
            'name': self.name,
            'price': self.price
        }
