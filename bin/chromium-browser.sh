#!/bin/sh

exec /usr/lib/chromium/chrome-original --disable-gpu --disable-software-rasterizer --use-gl=swiftshader --no-sandbox $@
