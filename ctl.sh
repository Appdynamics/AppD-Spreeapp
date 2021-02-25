#!/bin/bash
#
# Maintainer: David Ryder
#
CMD=${1:-"help"}
CMD_ARGS_LEN=${#}

# envvars
if [ -f envvars.sh ]; then
  . envvars.sh
else
  echo "Warning: envvars.sh not found"
fi

DOCKER_CMD=`which docker`
DOCKER_CMD=${DOCKER_CMD:-"/snap/bin/microk8s.docker"}
#echo "Using: "$DOCKER_CMD
if [ -d $DOCKER_CMD ]; then
    echo "Docker is missing: "$DOCKER_CMD
    exit 1
fi

_buildContainer() {
  DOCKERFILE="./$DOCKERFILES_DIR/$DOCKER_TAG_NAME.Dockerfile"
  echo "Building $DOCKERFILE Tag: $DOCKER_TAG_NAME"
  $DOCKER_CMD build \
    --build-arg USER=$USER \
    --build-arg HOME_DIR=$HOME_DIR \
    -t $DOCKER_TAG_NAME \
    --file $DOCKERFILE .
}

_dockerRun() {
  # Adds ports
  # Adds RW volume on host
  DOCKER_EXTRA_ARGS="$1"
  DOCKER_CONTAINER_ID=${2:-"0"}
  echo "Docker running $DOCKER_TAG_NAME ARGS[$DOCKER_EXTRA_ARGS]"
  $DOCKER_CMD run --rm --detach  \
            --name "$DOCKER_TAG_NAME$DOCKER_CONTAINER_ID" \
            --hostname "$DOCKER_TAG_NAME$DOCKER_CONTAINER_ID" \
            --network $DOCKER_NETWORK_NAME \
            $DOCKER_EXTRA_ARGS \
            -it                \
            $DOCKER_TAG_NAME

  # --volume /tmp/dock-$DOCKER_TAG_NAME:/$DOCKER_TAG_NAME:rw \
}

_getDockerContainerIdImage() {
  IMAGE_NAME=${1:-"Image Name Missing"}
  DOCKER_ID=`docker container ps --format '{{json .}}' \
    | jq --arg SEARCH_STR "$IMAGE_NAME" 'select(.Image | contains($SEARCH_STR))' \
    | jq -s '[.[] | {ID, Names, Image } ][0]' \
    | jq -r .ID`
    echo $DOCKER_ID
}

_getDockerContainerId() {
  IMAGE_NAME=${1:-"Image Name Missing"}
  DOCKER_ID=`docker container ps --format '{{json .}}' \
    | jq --arg SEARCH_STR "$IMAGE_NAME" 'select(.Names | contains($SEARCH_STR))' \
    | jq -s '[.[] | {ID, Names, Image } ][0]' \
    | jq -r .ID`
    echo $DOCKER_ID
}

_dockerBash() {
  CID=$(_getDockerContainerIdImage ${DOCKER_TAG_NAME})
  echo "Container ID $CID for ${DOCKER_TAG_NAME}"
  $DOCKER_CMD exec -it $CID /bin/bash
}

_dockerStop() {
  CONTAINER_ID=`_getDockerContainerId ${DOCKER_TAG_NAME}`
  if [ "$CONTAINER_ID" != "" ]; then
    echo "Stop ${DOCKER_TAG_NAME} ${CONTAINER_ID}"
    docker stop ${CONTAINER_ID} &
    sleep 5 # some time for container to stop
  else
    echo "Container ${DOCKER_TAG_NAME} is not running"
  fi
}

case "$CMD" in
  test)
    echo "Test"
    ;;
  build) # Expects Argument APP_ID
    DOCKER_TAG_NAME=${2:-"DOCKER_TAG_MISSING"}
    _buildContainer $DOCKER_TAG_NAME
    ;;
  run)
    docker network create -d bridge $DOCKER_NETWORK_NAME > /dev/null 2>&1
    DOCKER_TAG_NAME=${2:-"DOCKER TAG MISSING"}
    ID=${3:-"0"}
    EXTRA_ARGS=""
    if [ $DOCKER_TAG_NAME == "spreeapp1" ]; then
        EXTRA_ARGS="-p 3000:3000"
    elif [ $DOCKER_TAG_NAME == "spreeapp2" ]; then
        EXTRA_ARGS="-p 3001:3001"
    elif [ $DOCKER_TAG_NAME == "postgres" ]; then
        EXTRA_ARGS="-p 5432:5432"
    elif [ $DOCKER_TAG_NAME$ID == "mysql0" ]; then
        EXTRA_ARGS="-p 3306:3306"
    fi
    _dockerRun "$EXTRA_ARGS" $ID $DOCKER_TAG_NAME
  ;;
  stop)
    DOCKER_TAG_NAME=${2:-"DOCKER TAG MISSING"}
    _dockerStop
    ;;
  bash)
    DOCKER_TAG_NAME=${2:-"DOCKER TAG MISSING"}
    _dockerBash
    ;;
  *)
    echo "Not Found " "$@"
    ;;
esac
