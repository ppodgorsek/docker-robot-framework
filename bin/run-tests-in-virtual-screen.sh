#!/bin/bash

xvfb-run --server-args="-screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_COLOUR_DEPTH} -ac" robot --outputDir /opt/robotframework/reports ${ROBOT_OPTIONS} /opt/robotframework/tests
