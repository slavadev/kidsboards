#!/usr/bin/env bash

cd /home/app/webapp
bundle exec puma -C config/puma.rb -d