from app import db


class Location(db.Model):
    __tablename__ = "foodtruck_event"
    foodtruck_id = db.Column(
        db.Integer, db.ForeignKey("foodtruck.id"), primary_key=True
    )
    event_id = db.Column(db.Integer, db.ForeignKey("event.id"), primary_key=True)
    longitude = db.Column(db.Float)
    latitude = db.Column(db.Float)

    def serialize(self):
        return {
            "foodtruck_id": self.foodtruck_id,
            "event_id": self.event_id,
            "longitude": self.longitude,
            "latitude": self.latitude,
        }
