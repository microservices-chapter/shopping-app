#!/usr/bin/env bash

set -e
#set -x

# TODO: Add clean build start option
# TODO: use git diff to know what has changed, and only build that
declare -a services=(
  "config-server"
  "api-gateway"
  "inventory-service"
  "shopping-cart"
  "review-service"
)

echo "::Step 1/3: Removing existing images"
#docker-compose rm && true

echo "::Step 2/3: Building jars"
services_to_build=( "${services[@]}" )
# is a service specified in the cmd line arg?
if [ "$*" != "" ]; then
    services_to_build=( "$@" )
fi

for i in "../${services_to_build[@]}"
do
  echo "-- Building $i"
  cd $i
  ./gradlew clean
  ./gradlew build
  # TODO: build image as well
  cd ..
done

echo "::Step 3/3: Starting containers"
cd shopping-app
 # TODO: should only run built images
docker-compose up --build

#set +x
