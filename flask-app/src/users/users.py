from flask import Blueprint, request, jsonify, make_response
import json
from src import db


users = Blueprint('users', __name__)

# get list of all users
@users.route('/users', methods=['GET'])
def get_users():
    cursor = db.get_db().cursor()
    cursor.execute('select user_id, first_name,\
        last_name, email, city, state, zip from TraditionalUsers')
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
#TODO need to do this for a specific user not all users
@users.route('/attended_concerts', methods=['GET'])
def get_past_concerts_attended():
    cursor = db.get_db().cursor()
    query = '''
        SELECT TU.user_id, C.concert_id
        FROM AttendsBridge JOIN Concerts C JOIN TraditionalUsers TU on AttendsBridge.user_id = TU.user_id
        WHERE has_happened IS TRUE
    '''
    cursor.execute(query)
    column_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# get a list of concerts a user wants to attend

# update a user's profile information

# add a concert to the list of concerts that a user wants to attend

# delete a concert from the list of concerts that a user wants to attend