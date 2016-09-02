#!/usr/bin/env bash

cd /etc/rsyslog.d/
sed -i -- "s/LOGGLY_TOKEN_TO_REPLACE/$LOGGLY_TOKEN/g" *loggly.conf
(/configure-linux.sh -a $LOGGLY_SUBDOMAIN -u $LOGGLY_USER -p $LOGGLY_PASSWORD -t $LOGGLY_TOKEN) &
