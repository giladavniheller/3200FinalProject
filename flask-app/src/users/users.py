from flask import Blueprint, request, jsonify, make_response
import json
from src import db


users = Blueprint('users', __name__)

# get list of all users
@users.route('/users', methods=['GET'])
def get_users():
    cursor = db.get_db().cursor()
    cursor.execute('select user_id, first_name,\
        last_name, email, city, state, zip from users')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# get list of past concerts a user has attended

# get a list of concerts a user wants to attend

# update a user's profile information 
