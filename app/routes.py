from flask import request
from app import app
from app import db
from app.models import User

@app.route('/')
@app.route('/user', methods=['POST'])
def create():
    content = request.get_json(silent=True)
    u = User(username=content['username'], email=content['email'])
    db.session.add(u)
    db.session.commit()
    return str(u)
@app.route('/user/<id>', methods=['GET'])
def retrieve(id):
    u = User.query.get(id)
    return str(u)
@app.route('/users', methods=['GET'])
def list():
    users = User.query.all()
    return str(users)
@app.route('/user/<id>', methods=['DELETE'])
def delete(id):
    u = User.query.get(id)
    db.session.delete(u)
    db.session.commit()
    return(str(u))
