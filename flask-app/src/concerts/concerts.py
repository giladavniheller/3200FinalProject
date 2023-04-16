from flask import Blueprint, request, jsonify, make_response
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



