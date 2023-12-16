import hashlib
import datetime
from flask import Flask, request, jsonify
from flask_jwt_extended import JWTManager,create_access_token, jwt_required,get_jwt_identity
from pymongo import MongoClient
from pymongo.server_api import ServerApi
from bson.objectid import ObjectId

app = Flask(__name__)
jwt = JWTManager(app)

app.config['JWT_SECRET_KEY']="asdasdasdasd"
app.config['JWT_ACCESS_TOKEN_EXPIRES']=datetime.timedelta(days=1)

uri='mongodb+srv://udec:udec1234567890@cluster0.kviiyky.mongodb.net/?retryWrites=true&w=majority'

client = MongoClient(uri,server_api=ServerApi('1'))

db = client['udec']
sc = db['users']

@app.route('/api/v1/users',methods=['POST'])
#@jwt_required()
def create_user():
    new_user = request.get_json()
    new_user["password"]=hashlib.sha256(new_user["password"].encode("utf-8")).hexdigest()
    doc =sc.find_one( {"username":new_user["username"]})
    if not doc:
        sc.insert_one(new_user)
        return jsonify({"status":"Usuario creado de pana"}),201
    else:
        return jsonify({"status":"Usuario ya existe"}),400


@app.route("/api/v1/login", methods=["POST"])
def login():
     login_details = request.get_json()
     user = sc.find_one({"username" : login_details["username"]})
     if user:
          enc_pass = hashlib .sha256(login_details['password'].encode("utf-8")).hexdigest()
          if enc_pass ==user["password"]:
               access_token= create_access_token(identity=user["username"])
               return jsonify(access_token= access_token),200

     return jsonify({'msg':'Credenciales incorrectas'}),401


@app.route("/api/v1/user/<user_id>",methods=["DELETE"])
#@jwt_required()
def delete(user_id):
   
          delete_user = sc.delete_one({'_id':ObjectId(user_id)})
          if delete_user.deleted_count>0:
               return jsonify({"status" : "Usuario eliminado con exito"}),204
          else:
               return "",404
  





@app.route("/api/v1/usersAll",methods=["GET"])
#@jwt_required()
def get_all_users():
     users = sc.find()
     data=[]
     for user in users:
          user["_id"] = str(user["_id"])
          data.append(user) 
     return jsonify(data)




if __name__ == '__main__':
     app.run(debug=True) 