# Use an official conda base image
#FROM continuumio/miniconda3
FROM python:3.12.5

# Set the working directory
WORKDIR /app

# Copy the environment.yml file into the container
COPY environment.yml .

# Create the conda environment
RUN conda env create -f environment.yml

# Make sure the environment is activated
SHELL ["conda", "run", "-n", "your_environment_name", "/bin/bash", "-c"]

# Install any additional packages or run any additional commands here
# For example, to install additional packages:
# RUN conda install -n your_environment_name some_package

# Set the default command to run when the container starts
CMD ["conda", "run", "-n", "your_environment_name", "python", "your_script.py"]

# Replace "your_environment_name" with the name of the environment specified in the environment.yml file
# Replace "your_script.py" with the script you want to run