#!/usr/bin/env bash

CONTAINER_NAME="kidsboards_api_"
# lets find the first container
FIRST_NUM=`docker ps | awk '{print $NF}' | grep $CONTAINER_NAME | awk -F  "_" '{print $NF}' | sort | head -1`
NUM_OF_CONTAINERS=1
MAX_NUM_OF_CONTAINERS=2

docker-compose -f prod.yml build api
docker-compose -f prod.yml scale api=$MAX_NUM_OF_CONTAINERS

# waiting for new containers
sleep 90

# removing old containers
for ((i=$FIRST_NUM;i<$NUM_OF_CONTAINERS+$FIRST_NUM;i++))
do
   docker stop $CONTAINER_NAME$i
   docker rm $CONTAINER_NAME$i
done

docker-compose -f prod.yml scale api=$NUM_OF_CONTAINERS


