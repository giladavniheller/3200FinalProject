from flask import Blueprint, request, jsonify, make_response, current_app
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


# get list of concerts a user has attended or will attend
@users.route('/attended_concerts', methods=['GET'])
def get_past_concerts_attended():

    user_id_use = request.args.get('user_id')

    cursor = db.get_db().cursor()
    query = '''
        SELECT DISTINCT *
        FROM AttendsBridge as ab JOIN Concerts as c on ab.concert_id = c.concert_id
        JOIN Venues as v on c.venue_id = v.venue_id JOIN PerformsBridge as pb on c.concert_id = pb.concert_id
        JOIN Artists as a on pb.artist_id = a.artist_id
        WHERE ab.user_id = %s ''' % user_id_use
    
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

# get a list of concerts a user wants to attend (desired concerts)
@users.route('/desired_concerts', methods=['GET'])
def get_past_concerts_desired():

    user_id_use = request.args.get('user_id')

    cursor = db.get_db().cursor()
    query = '''
        SELECT DISTINCT *
        FROM FavoritesBridge as fb JOIN Concerts as c on fb.concert_id = c.concert_id
        JOIN Venues as v on c.venue_id = v.venue_id JOIN PerformsBridge as pb on c.concert_id = pb.concert_id
        JOIN Artists as a on pb.artist_id = a.artist_id
        WHERE fb.user_id = %s ''' % user_id_use
    
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

    user_id_use = request.args.get('user_id')

    theData = request.json
    current_app.logger.info(theData) 

    fName = theData['FirstName_input']
    lName = theData['LastName_input']
    email = theData['Email_input']
    city = theData['City_input']
    state = theData['State_input']
    zip = theData['Zip_input']

    query = 'UPDATE TraditionalUsers SET email = '
    
    query += '"' + email + '"' + ', first_name = "'
    query += fName + '", last_name = "'
    query += lName + '", city = "'
    query += city + '", state = "'
    query += state + '", zip = "'
    query += str(zip) + '" WHERE user_id = '
    query += str(user_id_use)

    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'



# add a concert to the list of concerts that a user wants to attend
@users.route('/update_favorites', methods=['POST'])
def post_update_favorites():
    theData = request.json
    current_app.logger.info(theData) 

    concert_id_use = theData['concert_id']
    #lName = theData['concert_id']
    user_id_use = request.args.get('user_id')
    #concert_id_use = request.args.get('concert_id')
        
    query = 'INSERT INTO FavoritesBridge (user_id, concert_id) VALUES ("'
    query += str(user_id_use) + '", "'
    query += str(concert_id_use) + '")'
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'



# add a concert to the list of concerts that a user has attended or will be attending
@users.route('/update_attends', methods=['POST'])
def post_update_attends():
    theData = request.json
    current_app.logger.info(theData) 

    concert_id_use = theData['concert_id']
    #lName = theData['concert_id']
    user_id_use = request.args.get('user_id')
    #concert_id_use = request.args.get('concert_id')
        
    query = 'INSERT INTO AttendsBridge (user_id, concert_id) VALUES ("'
    query += str(user_id_use) + '", "'
    query += str(concert_id_use) + '")'
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'



# delete a concert from the list of concerts that a user wants to attend
@users.route('/remove_from_favorites', methods=['DELETE'])
def remove_from_favorites():
    theData = request.json
    current_app.logger.info(theData) 

    concert_id_use = theData['concert_id']
    #lName = theData['concert_id']
    user_id_use = request.args.get('user_id')
    #concert_id_use = request.args.get('concert_id')
        
    query = 'DELETE FROM FavoritesBridge WHERE user_id = "'
    query += str(user_id_use) + '" and concert_id =  "'
    query += str(concert_id_use) + '"'
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'


# delete a concert from the list of concerts that a user is attending/has attended
@users.route('/remove_from_attends', methods=['DELETE'])
def remove_from_attended():
    theData = request.json
    current_app.logger.info(theData) 

    concert_id_use = theData['concert_id']
    #lName = theData['concert_id']
    user_id_use = request.args.get('user_id')
    #concert_id_use = request.args.get('concert_id')
        
    query = 'DELETE FROM AttendsBridge WHERE user_id = "'
    query += str(user_id_use) + '" and concert_id =  "'
    query += str(concert_id_use) + '"'
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'


# get info for specific user
@users.route('/users/info', methods=['GET'])
def get_user_info():

    user_id_use = request.args.get('user_id')

    cursor = db.get_db().cursor()
    cursor.execute('''select user_id, first_name,\
        last_name, email, city, state, zip from TraditionalUsers WHERE user_id = %s ''' % user_id_use)
    

    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


