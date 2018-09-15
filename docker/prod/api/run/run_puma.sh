#!/usr/bin/env bash

cd /home/app/webapp
rm -f /home/app/webapp/puma.pid
bundle exec puma -c config/puma.rb -E production -D
