from flask import Blueprint, request, jsonify, make_response, current_app
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

# # Get all the concerts from a specific venue from the database
@venues.route('/venueHome', methods=['GET'])
def get_venue_concerts():


    venue_id_use = request.args.get('venue_id')
# get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of products
    cursor.execute("""
                    SELECT show_date as 'Date', HeadlinerName as 'Headliner(s)', OpenerName as 'Opener(s)', ticket_price as 'Price', sold_out as 'Sold Out?', has_happened as 'Show Already Happened?', link_to_tickets as 'Buy Tickets', headliners.concert_id as 'ID'
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
    """ % venue_id_use)

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




# # toggle the sell state of the concert
@venues.route('/toggleSoldOut', methods=['PUT'])
def toggle_sold_out():

    theData = request.json
    current_app.logger.info(theData) 

    concert_id_use = theData['selected_concert_id']

    query = 'UPDATE Concerts SET sold_out = NOT sold_out WHERE concert_id = "'
    query += str(concert_id_use) + '"'
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()


    return 'Success', 200


# add a new concert to Concerts
@venues.route('/createConcert/', methods=['POST'])
def create_new_concert():
    theData = request.json
    current_app.logger.info(theData) 

    venue_id = request.args.get('venue_id')

    ticket_price = theData['TicketPrice']
    ticket_link = theData['LinkToBuyTickets']
    show_date = theData['ShowDate']
    sold_out = theData['SoldOut']


    headliners = theData['HeadlinerSelect']
    openers = theData['OpenerSelect']
    #concert_id_use = request.args.get('concert_id')

    query = f'INSERT INTO Concerts (ticket_price, sold_out, show_date, link_to_tickets, venue_id) VALUES ('
    query += str(ticket_price) + ', '
    query += str(sold_out) + ', "'
    query += str(show_date[:10]) + '", '
    query += ('"' + str(ticket_link) + '", ') if ticket_link != "" else 'NULL, '
    query += str(venue_id) + ')'
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    concert_id = cursor.lastrowid

    headliners_assigned = assign_headliners(headliners=headliners, concert_id=concert_id)
    openers_assigned = assign_openers(openers=openers, concert_id=concert_id)

    return 'Success!' if headliners_assigned == "Success!" and openers_assigned == "Success!" else "Uh oh!"


@venues.route('/assignHeadliners/', methods=['POST'])
def assign_headliners(headliners, concert_id):

    for artist_id in headliners:

        query = 'INSERT INTO PerformsBridge (artist_id, concert_id, is_headliner) VALUES ('
        query += str(artist_id) + ', '
        query += str(concert_id) + ', '
        query += '1)'
        current_app.logger.info(query)

        cursor = db.get_db().cursor()
        cursor.execute(query)
        db.get_db().commit()

    return 'Success!'

@venues.route('/assignOpeners/', methods=['POST'])
def assign_openers(openers, concert_id):

    for artist_id in openers:

        query = 'INSERT INTO PerformsBridge (artist_id, concert_id, is_headliner) VALUES ('
        query += str(artist_id) + ', '
        query += str(concert_id) + ', '
        query += '0)'
        current_app.logger.info(query)

        cursor = db.get_db().cursor()
        cursor.execute(query)
        db.get_db().commit()

    return 'Success!'

# get list of all concerts
@venues.route('/concerts', methods=['GET'])
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
@venues.route('/delete_concert', methods=['DELETE'])
def delete_concert():
    theData = request.json
    current_app.logger.info(theData) 

    concert_id_use = theData['concert_id']
    #lName = theData['concert_id']
    user_id_use = request.args.get('user_id')
    #concert_id_use = request.args.get('concert_id')
        
    query = 'DELETE FROM Concerts WHERE concert_id = "'
    query += str(concert_id_use) + '"'
    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'



# update a user's profile information
@venues.route('/update_profile', methods=['PUT'])
def put_update_profile():

    venue_id_use = request.args.get('venue_id')

    theData = request.json
    current_app.logger.info(theData) 

    vName = theData['VenueName_input']
    vHours = theData['VenueHours_input']
    cap = theData['Capacity_input']
    city = theData['City_input']
    state = theData['State_input']
    zip = theData['Zip_input']

    query = 'UPDATE Venues SET venue_name = '
    
    query += '"' + vName + '"' + ', venue_hours = "'
    query += vHours + '", capacity = "'
    query += str(cap) + '", city = "'
    query += city + '", state = "'
    query += state + '", zip = "'
    query += str(zip) + '" WHERE venue_id = '
    query += str(venue_id_use)

    current_app.logger.info(query)

    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return 'Success!'


# get info for specific venue
@venues.route('/venues/info', methods=['GET'])
def get_venue_info():

    venue_id_use = request.args.get('venue_id')

    cursor = db.get_db().cursor()
    cursor.execute('''select venue_id, venue_name,\
        venue_hours, capacity, city, state, zip from Venues WHERE venue_id = %s ''' % venue_id_use)
    

    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response