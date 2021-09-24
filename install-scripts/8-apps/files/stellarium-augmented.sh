#!/bin/bash

# hack to control stellarium azimuth by true north heading from signalK

stellarium "$@"  &
sleep 30

while [[ -n "$(pidof stellarium)" ]]
do
  # magnetic variation
  MV=$(curl -s http://localhost:3000/signalk/v1/api/vessels/self/navigation/magneticVariation/value)
  # magnetic heading
  MH=$(curl -s http://localhost:3000/signalk/v1/api/vessels/self/navigation/headingMagnetic/value)
  # true heading
  HT=$(echo $MH + $MV | bc)
  # control stellarium azimuth
  curl -X POST -d "az=$HT" 'http://localhost:8090/api/main/view'
  # control stellarium location  
  POS="$(curl -s http://localhost:3000/signalk/v1/api/vessels/self/navigation/position/ | jq -M -jr '"latitude=",.value.latitude,"&longitude=",.value.longitude')"
  curl -X POST -d "altitude=0&${POS}&name=Current" 'http://localhost:8090/api/location/setlocationfields'
  sleep 3
done
