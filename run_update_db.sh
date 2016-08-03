#!/usr/bin/env bash

docker-compose -f prod.yml run migrator bash -c "bundle exec rake db:create && bundle exec rake db:migrate"

