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
    image1 = db.Column(db.Text)  
    image2 = db.Column(db.Text) 
    poster_username = db.Column(db.String(80), nullable=False)
    date = db.Column(db.DateTime, nullable=False)
    is_still_there = db.Column(db.Integer, default=0)
    is_no_longer_there = db.Column(db.Integer, default=0)

    def __repr__(self):
        return f'<Post {self.sector}>'
    
class Comment(db.Model):
    __tablename__ = "comment"
    
    id = db.Column(db.Integer, primary_key=True)
    post_id = db.Column(db.Integer, nullable=False)
    content = db.Column(db.Text, nullable=False)
    poster_username = db.Column(db.String(80), nullable=False)
    date = db.Column(db.DateTime, nullable=False)

    def __repr__(self):
        return f'<Comment {self.sector}>'