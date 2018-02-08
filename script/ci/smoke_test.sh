#!/bin/sh
# Ensure basic auth is enabled for /events.
curl --verbose --silent --request POST --url "$APP_URL/events" 2>&1 | grep "HTTP/1.1 401 Unauthorized" > /dev/null || exit 1
