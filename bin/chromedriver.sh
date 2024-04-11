#!/bin/sh

exec /opt/chrome-for-testing/chromedriver-linux64/chromedriver --verbose --log-path=/var/log/chromedriver --no-sandbox "$@"