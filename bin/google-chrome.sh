#!/bin/sh

# Xvfb is used to run Chrome in a virtual X server, as there is no graphical interface.
xvfb-run /usr/bin/google-chrome
