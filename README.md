# AppD-Spreeapp

Containerized instrumentation of the Spree Commerce application using with AppDynamics

# Configure the AppDynamics controller information in the file:
spreeapp-config/appdynamics.yml

# Build the Container
./ctl.sh build spreeapp1

# Start the container
./ctl.sh run spreeapp1


The container starts a simple load generator on the Spree application

Review the AppDynamics controller for the Application SpreeApp1

# Bash into the container to review the configuration
./ctl.sh bash spreeapp1

# Stop the container
./ctl.sh stop spreeapp1
<<<<<<< HEAD
=======

>>>>>>> 2cdab4ebdec35626ee521cd50ca50b4e8253bad4
