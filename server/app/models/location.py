from app import db


class Location(db.Model):
    __tablename__ = "foodtruck_event"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    foodtruck_id = db.Column(db.Integer, db.ForeignKey("foodtruck.id"), nullable=False)
    event_id = db.Column(db.Integer, db.ForeignKey("event.id"), nullable=False)
    longitude = db.Column(db.Float)
    latitude = db.Column(db.Float)

    def serialize(self):
        return {
            "id": self.id,
            "foodtruck_id": self.foodtruck_id,
            "event_id": self.event_id,
            "longitude": self.longitude,
            "latitude": self.latitude,
        }
