#!/bin/sh

exec /opt/robotframework/drivers/msedgedriver-original --disable-dev-shm-usage --verbose --log-path=/var/log/msedgedriver "$@"
