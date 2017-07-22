#!/bin/sh

echo "pouet pouet" >> /home/robot/test

/usr/lib64/chromium-browser/chromium-browser-original --disable-gpu --no-sandbox $@

