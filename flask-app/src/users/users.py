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
#TODO need to do this for a specific user not all users
@users.route('/desired_concerts', methods=['GET'])
def get_past_concerts_desired():
    cursor = db.get_db().cursor()
    query = '''
        SELECT c.concert_id, c.ticket_price, c.sold_out, c.show_date, c.has_happened, c.link_to_tickets, c.venue_id
        FROM Concerts c
        INNER JOIN FavoritesBridge fb ON c.concert_id = fb.concert_id
        WHERE fb.user_id = <user_id>;
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

# update a user's profile information
@users.route('/update_profile', methods=['PUT'])
def put_update_profile():
    theData = request.json
    current_app.logger.info(theData) 

    fName = theData['first_name']
    lName = theData['last_name']
    email = theData['email']

    query = '''
        UPDATE TraditionalUsers
        SET email = '<new_email>', first_name = '<new_first_name>', last_name = '<new_last_name>'
        WHERE user_id = <user_id>;
    '''


# add a concert to the list of concerts that a user wants to attend
@users.route('/update_favorites', methods=['POST'])
def post_update_favorites():
    theData = request.json
    current_app.logger.info(theData) 

    user_id = theData['user_id']
    lName = theData['concert_id']
        
    query = 'INSERT INTO FavoritesBridge (user_id, concert_id) VALUES ("'
    query += user_id + '", "'
    query += concert_id + ')'
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'

# delete a concert from the list of concerts that a user wants to attend


