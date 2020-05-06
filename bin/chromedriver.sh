#!/bin/sh

exec /usr/bin/chromedriver --verbose --log-path=/var/log/chromedriver --no-sandbox $@

