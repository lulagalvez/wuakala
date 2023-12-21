from flask import (
    render_template,
    request,
    session,
    jsonify
)
from datetime import datetime
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity
from app import create_app,db,bcrypt
from models import User, Post, Comment

app = create_app()

@app.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    user = User.query.filter_by(email=email).first()
    if user and bcrypt.check_password_hash(user.pwd, password):
        access_token = create_access_token(identity=user.id)
        return jsonify(access_token=access_token), 200

    return jsonify(message="Invalid credentials"), 401

@app.route("/register", methods=["POST"])
def register():
    data = request.get_json()
    username = data.get('username')
    email = data.get('email')
    password = data.get('password')

    existing_user = User.query.filter_by(email=email).first()
    if existing_user:
        return jsonify(message="Email already registered"), 400

    new_user = User(
        username=username,
        email=email,
        pwd=bcrypt.generate_password_hash(password).decode('utf-8')
    )
    db.session.add(new_user)
    db.session.commit()

    return jsonify(message="Registration successful"), 201

@app.route("/users")
def get_users():
    users = User.query.all()

    user_list = [
        {
            'id': user.id,
            'username': user.username,
            'email': user.email,
        }
        for user in users
    ]
    return jsonify(users=user_list)

@app.route("/posts", methods=["GET"])
@jwt_required()
def get_all_posts():
    all_posts = Post.query.all()

    posts_list = [
        {
            "id": post.id,
            "sector": post.sector,
            "description": post.description,
            "image1": post.image1,
            "image2": post.image2,
            "poster_username": post.poster_username,
            "date": post.date,
        }
        for post in all_posts
    ]
    return jsonify(posts=posts_list), 200

@app.route("/posts", methods=["POST"])
@jwt_required()
def create_post():
    data = request.get_json()
    current_user_id = get_jwt_identity()
    user = User.query.get(current_user_id)

    if not user:
        return jsonify(message="User not found"), 404
    
    new_post = Post(
        sector=data.get('sector'),
        description=data.get('description'),
        image1=data.get('image1'),
        image2=data.get('image2'),
        poster_username=user.username,
        date=datetime.now()
    )
    db.session.add(new_post)
    db.session.commit()
    return jsonify(message="Post created successfully"), 201

@app.route("/posts/<int:post_id>", methods=["DELETE"])
def delete_post(post_id):
    post = Post.query.get_or_404(post_id)
    db.session.delete(post)
    db.session.commit()
    return jsonify(message="Post deleted successfully"), 200

@app.route("/posts/<int:post_id>/is_still_there", methods=["PATCH"])
def increment_is_still_there(post_id):
    post = Post.query.get_or_404(post_id)
    post.is_still_there += 1
    db.session.commit()
    return jsonify(message="is_still_there incremented successfully"), 200

@app.route("/posts/<int:post_id>/is_no_longer_there", methods=["PATCH"])
def increment_is_no_longer_there(post_id):
    post = Post.query.get_or_404(post_id)
    post.is_no_longer_there += 1
    db.session.commit()
    return jsonify(message="is_no_longer_there incremented successfully"), 200

@app.route("/comments/<int:post_id>", methods=["POST"])
@jwt_required()
def create_comment(post_id):
    data = request.get_json()
    current_user_id = get_jwt_identity()
    user = User.query.get(current_user_id)

    if not user:
        return jsonify(message="User not found"), 404
    
    new_comment = Comment(
        content = data.get('content'),
        post_id = post_id,
        date=datetime.now(),
        poster_username=user.username
    )
    db.session.add(new_comment)
    db.session.commit()
    return jsonify(message="Comment created successfully")

@app.route("/comments/<int:post_id>", methods=["GET"])
def get_comments_by_post_id(post_id):
    comments = Comment.query.filter_by(post_id=post_id).all()

    if not comments:
        return jsonify(message="No comments found for this post"), 404

    comments_list = [
        {
            'id': comment.id,
            'post_id': comment.post_id,
            'content': comment.content,
            'poster_username': comment.poster_username,
            'date': comment.date.strftime("%Y-%m-%d %H:%M:%S")
        }
        for comment in comments
    ]
    return jsonify(comments=comments_list)
 
if __name__ == "__main__":
    app.run(debug=True)