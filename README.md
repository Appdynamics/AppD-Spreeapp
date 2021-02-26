# AppDynmaics Spree Commerce Application Instrumentation

Containerized instrumentation of the Spree Commerce application using AppDynamics 

Requires: docker and jq

## Configure the AppDynamics controller information in the file:

```spreeapp-config/appdynamics.yml
```

## Build the Container

```./ctl.sh build spreeapp1
```

## Start the container

```./ctl.sh run spreeapp1
```

The container starts a simple load generator on the Spree application

Review the AppDynamics controller for the Application SpreeApp1

## Bash into the container to review the configuration

```./ctl.sh bash spreeapp1
```

## Stop the container

```./ctl.sh stop spreeapp1
```
