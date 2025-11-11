#!/bin/sh

exec /opt/robotframework/drivers/msedgedriver-original --verbose --log-path=/var/log/msedgedriver "$@" || cat /var/log/msedgedriver
