#!/usr/bin/env bash

cd /home/app/webapp
rm -f /home/app/webapp/unicorn.pid
bundle exec unicorn -c config/unicorn.rb -E production -D