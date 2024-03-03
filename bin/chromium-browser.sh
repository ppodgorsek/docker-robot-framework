#!/bin/sh

exec /usr/lib64/chromium-browser/chromium-browser-original --disable-gpu --disable-software-rasterizer --use-gl=swiftshader --no-sandbox "$@"
