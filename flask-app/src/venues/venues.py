from flask import Blueprint, request, jsonify, make_response
import json
from src import db


venues = Blueprint('venues', __name__)

# # Get all the venues from the database
@venues.route('/getVenues', methods=['GET'])
def get_venues():
# get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of products
    cursor.execute('SELECT * FROM Venues')

    # grab the column headers from the returned data
    column_headers = [x[0] for x in cursor.description]

    # create an empty dictionary object to use in 
    # putting column headers together with data
    json_data = []

    # fetch all the data from the cursor
    theData = cursor.fetchall()

    # for each of the rows, zip the data elements together with
    # the column headers. 
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)

# # Get all the venues from the database
@venues.route('/venueHome/<venueId>', methods=['GET'])
def get_venue_concerts(venueId):
# get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of products
    cursor.execute("""
                    SELECT show_date as 'Date', HeadlinerName as 'Headliner(s)', OpenerName as 'Opener(s)', ticket_price as 'Price', sold_out as 'Sold Out?', has_happened as 'Show Already Happened?', link_to_tickets as 'Buy Tickets'
                FROM
                (SELECT Concerts.concert_id, GROUP_CONCAT(artist_name SEPARATOR ', ') as "HeadlinerName", venue_id, ticket_price, sold_out, show_date, has_happened, link_to_tickets
                                        FROM Concerts
                                                    JOIN PerformsBridge on Concerts.concert_id = PerformsBridge.concert_id
                                                    JOIN Artists on PerformsBridge.artist_id = Artists.artist_id
                                        WHERE PerformsBridge.is_headliner = True
                    GROUP BY concert_id) as headliners
                LEFT JOIN
                (SELECT Concerts.concert_id, GROUP_CONCAT(artist_name SEPARATOR ', ') as "OpenerName", venue_id
                                        FROM Concerts
                                                    JOIN PerformsBridge on Concerts.concert_id = PerformsBridge.concert_id
                                                    JOIN Artists on PerformsBridge.artist_id = Artists.artist_id
                                        WHERE PerformsBridge.is_headliner = False
                                        GROUP BY concert_id) as openers
                ON headliners.concert_id = openers.concert_id
                WHERE headliners.venue_id = %s
    """ % venueId)

    # grab the column headers from the returned data
    column_headers = [x[0] for x in cursor.description]

    # create an empty dictionary object to use in 
    # putting column headers together with data
    json_data = []

    # fetch all the data from the cursor
    theData = cursor.fetchall()

    # for each of the rows, zip the data elements together with
    # the column headers. 
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)

# # get the top 5 products from the database
# @products.route('/mostExpensive')
# def get_most_pop_products():
#     cursor = db.get_db().cursor()
#     query = '''
#         SELECT product_code, product_name, list_price, reorder_level
#         FROM products
#         ORDER BY list_price DESC
#         LIMIT 5
#     '''
#     cursor.execute(query)
#        # grab the column headers from the returned data
#     column_headers = [x[0] for x in cursor.description]

#     # create an empty dictionary object to use in 
#     # putting column headers together with data
#     json_data = []

#     # fetch all the data from the cursor
#     theData = cursor.fetchall()

#     # for each of the rows, zip the data elements together with
#     # the column headers. 
#     for row in theData:
#         json_data.append(dict(zip(column_headers, row)))

#     return jsonify(json_data)