# Use an official conda base image
FROM continuumio/miniconda3

# Set the working directory
WORKDIR /app

# Copy the environment.yml file into the container
COPY environment.yml .

# Create the conda environment
RUN conda env create -f environment.yml

# Make sure the environment is activated
SHELL ["conda", "run", "-n", "postgresql", "/bin/bash", "-c"]

# Install any additional packages or run any additional commands here
# For example, to install additional packages:
# RUN conda install -n postgresql some_package

# Copy the SQL files into the container
COPY postgres_tutorial.sql /app/postgres_tutorial.sql
COPY create_some_tables_and_data.sql /app/create_some_tables_and_data.sql
COPY postgres_docker_setup.ipynb /app/postgres_docker_setup.ipynb

# Set the default command to run when the container starts
#CMD ["conda", "run", "-n", "postgresql", "psql", "-h", "pgdatabase", "-U", "postgres", "-d", "dvdrental", "-f", "/app/postgresql_tutorial.sql"]
CMD ["conda", "run", "-n", "postgresql", "tail", "-f", "/dev/null"]
# Replace "postgresql" with the name of the environment specified in the environment.yml file