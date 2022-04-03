#!/bin/sh

exec /usr/lib64/chromium-browser/chromium-browser-original --disable-gpu --no-sandbox "$@"
