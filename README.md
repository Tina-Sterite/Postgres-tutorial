Ctl + Shift + V - to preview markdown file
Ctl + K V - open preview to the side


# *****  N T A I  &emsp;  P O S T G R E S Q L &nbsp;  C E R T I F I C A T I O N  *****
follow along -> postgresqltutorial.com \
(note: since the completion of this project the website has changed to https://neon.tech/postgresql/tutorial)

Modifying the queries noted throughout the tutorial to show comprehension (see postgres_tutorial.sql)

Project Files:
- postgres_tutorial.sql - is the work completed to show comprehension.
- create_some_tables_and_data.sql - was used to add more tables/data to work with during the tutorial.
- docker-compose.yaml and Dockerfile - used in Docker Environment Setup - instructions below.

## Docker Environment Setup
Contains 
- database
- SQL files
- environment

(FYI, an environment.yml file is included, however, this was used to setup my environment which is now included in the docker image - so it is not needed for your setup purposes.)

STEPS: \
Please Note: if you are viewing raw text in VS Code, do not copy the \ at the end of the command, the \ is meant to add a newline in a rendered markdown file and is not part of the command.
- in your VS Code terminal run the following commands in the order listed - don't forget the period at the end of the first command:\
    docker build -t postgres-cert -f Dockerfile .\
    docker run -t -i postgres-cert

## Connect pgAdmin to PostgreSQL:

STEPS: \
Access pgAdmin: Open your web browser and go to http://localhost:8080.

Log in to pgAdmin: Use the email admin@admin.com and password admin to log in.

Add a New Server in pgAdmin:

Right-click on "Servers" in the left sidebar and select "Create" > "Server...".
In the "General" tab, enter a name for the server (e.g., dvdrental).
In the "Connection" tab, enter the following details:
Host name/address: pgdatabase
Port: 5432
Username: postgres
Password: sup3Rus3R
Click "Save" to create the server connection.


## Project Next steps: 
- https://neon.tech/postgresql/postgresql-python
- Create a Python file to perform the same SQL steps as in the SQL files
