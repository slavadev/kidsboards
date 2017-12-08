#!/usr/bin/env bash

docker-compose -f prod.yml run frontend-updator bash -c "npm install && bower install --allow-root && gulp build"

