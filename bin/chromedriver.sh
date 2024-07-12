#!/bin/sh

exec /chromedriver/linux-${CHROME_VERSION}/chromedriver-linux64/chromedriver --verbose --log-path=/var/log/chromedriver --no-sandbox "$@"
