#!/usr/bin/env bash

docker-compose -f prod.yml build
./run_update_db.sh
./run_update_frontend.sh


