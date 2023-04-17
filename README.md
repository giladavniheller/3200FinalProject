# MySQL + Flask Boilerplate Project
## TODO Delete this
This repo contains a boilerplate setup for spinning up 3 Docker containers: 
1. A MySQL 8 container for obvious reasons
1. A Python Flask container to implement a REST API
1. A Local AppSmith Server


# MuseMatchLive
### Overview
MuseMatchLive is an application that makes finding and planning concerts easier for concert-goers, artists, and venue managers alike. The app allows data to be maintained, shared, and quickly accessed regarding past and future concerts. Users can create different profiles for venues, artists, and traditional users, all of which have their respective public facing pages. 

### What can you do in MuseMatchLive?
- Venues can post listings for the concerts they are hosting
- Artists can post listings for upcoming concerts they are performing and a list of concerts they have performed 
- Traditional users can keep track the concerts they have or will attend, as well as concerts they'd like to attend


## How to setup and start the containers
**Important** - you need Docker Desktop installed

1. Clone this repository.  
1. Create a file named `db_root_password.txt` in the `secrets/` folder and put inside of it the root password for MySQL. 
1. Create a file named `db_password.txt` in the `secrets/` folder and put inside of it the password you want to use for the a non-root user named webapp. 
1. In a terminal or command prompt, navigate to the folder with the `docker-compose.yml` file.  
1. Build the images with `docker compose build`
1. Start the containers with `docker compose up`.  To run in detached mode, run `docker compose up -d`. 




