#!/usr/bin/env bash

NEW_RELIC_AGENT_ENABLED=false docker-compose -f prod.yml --project-name=thatsaboy $@


