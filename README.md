# MuseMatchLive

## Overview

MuseMatchLive is an application that makes finding and planning concerts easier for concert-goers, artists, and venue managers alike. The app allows for data to be maintained, shared, and quickly accessed regarding past and future concerts. Application goers can create different profiles for venues, artists, and traditional users, all of which have their respective public facing pages.

### Traditional Users

This user persona is for the average concert-goer. Users will be able to log the concerts they have attended or have bought tickets for (will attend), or can favorite/save concerts that they're interested in. Users will have relevant data saved to their profile (name, email, location, etc.) and will be able to update this information if they choose.

### Venues

This user persona is for the owner of a music venue. Venues will be able to see the concerts they are hosting or have hosted, and will be able to create new concert listings to add to their page. These new concert listings will specify the date of the upcoming concert, any headlining/opening artists that will perform, and other relevant details such as the ticket price. Venues also have the full functionality to modify and delete these listings if they so choose.

## How to setup and start the containers

**Important** - you need Docker Desktop installed

1. Clone this repository.
2. Create a file named `db_root_password.txt` in the `secrets/` folder and put inside of it the root password for MySQL.
3. Create a file named `db_password.txt` in the `secrets/` folder and put inside of it the password you want to use for the a non-root user named webapp.
4. Copy and run the sql file `MuseMatchLiveDB`
5. In a terminal or command prompt, navigate to the folder with the `docker-compose.yml` file.
6. Build the images with `docker compose build`
7. Start the containers with `docker compose up`. To run in detached mode, run `docker compose up -d`.

## Link to the video pitch:

https://drive.google.com/file/d/1igdiwFXHJdQgkByC0DCkrcysEWU_V36b/view?usp=sharing
