#!/bin/sh

exec /opt/robotframework/drivers/msedgedriver-original --user-data-dir=${ROBOT_WORK_DIR}/msedge/ --verbose --log-path=/var/log/msedgedriver "$@"
