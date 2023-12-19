from app import db
from flask_login import UserMixin

class User(UserMixin, db.Model):
    __tablename__ = "user"
    
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    pwd = db.Column(db.String(300), nullable=False, unique=True)

    def __repr__(self):
        return '<User %r>' % self.username
    
class Post(db.Model):
    __tablename__ = "post"
    
    id = db.Column(db.Integer, primary_key=True)
    sector = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=False)
    image1 = db.Column(db.Text)  # Assuming base64 images are stored as text
    image2 = db.Column(db.Text)  # Assuming base64 images are stored as text
    poster_username = db.Column(db.String(80), nullable=False)
    date = db.Column(db.DateTime, nullable=False)
    is_still_there = db.Column(db.Integer, default=0)
    is_no_longer_there = db.Column(db.Integer, default=0)

    def __repr__(self):
        return f'<Post {self.sector}>'