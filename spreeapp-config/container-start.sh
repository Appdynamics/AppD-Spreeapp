#!/bin/bash
#
# Maintainer: David Ryder

_SpreeAppLoadGen() {
  INTERATIONS_N=999999
  INTERVAL_SEC=5
  DURATION_SEC=7200

  HOST="localhost"
  PORT="3000"
  API="/"

  URL_LIST=("/t/bags" "/t/mugs" "/t/clothing" "/t/ruby" "/t/apache" "/t/spree" "/cart" "/")
  URL_LIST_LEN=${#URL_LIST[@]}

  echo "Starting loadgen"
  START_TIME=$(date +%s)
  END_TIME=$(( START_TIME + DURATION_SEC ))
  for i in $(seq $INTERATIONS_N )
  do
    URL_N=$(( RANDOM % URL_LIST_LEN ))
    API="${URL_LIST[$URL_N]}"
    echo "Calling: $HOST:$PORT$API $i"
    curl -G $HOST:$PORT$API
    TIME_NOW=$(date +%s)
    echo $TIME_NOW $END_TIME
    if [ "$TIME_NOW" -gt "$END_TIME" ]; then
      echo "Stopping"
      break;
    else
      sleep $INTERVAL_SEC
    fi
  done
  echo "Stopping loadgen"
}


cd /spree/sandbox

bundle install

rails s -b 0.0.0.0 -p 3000 &


_SpreeAppLoadGen
