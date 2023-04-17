from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


concerts = Blueprint('concerts', __name__)


# get list of all concerts
@concerts.route('/concerts', methods=['GET'])
def get_concerts():
    cursor = db.get_db().cursor()
    cursor.execute('''select * from Concerts c JOIN Venues as v on c.venue_id = v.venue_id
                   JOIN PerformsBridge as pb on pb.concert_id = c.concert_id
                   JOIN Artists as a on a.artist_id = pb.artist_id''')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# delete a concert listing
@concerts.route('/delete_concert', methods=['DELETE'])
def delete_concert():
    theData = request.json
    current_app.logger.info(theData) 

    concert_id_use = theData['concert_id']
    #lName = theData['concert_id']
    #user_id_use = request.args.get('user_id')
    #concert_id_use = request.args.get('concert_id')
        
    query = 'DELETE FROM Concerts WHERE concert_id = '
    query += str(concert_id_use)
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'


