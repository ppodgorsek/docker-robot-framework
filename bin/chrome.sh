#!/bin/sh

exec /chrome/linux-${CHROME_VERSION}/chrome-linux64/chrome --disable-gpu --no-sandbox "$@"
