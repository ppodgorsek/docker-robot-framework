FROM python:2.7-alpine3.9

MAINTAINER Paul Podgorsek <ppodgorsek@users.noreply.github.com>
LABEL description Robot Framework in Docker.

# Setup volume for output
VOLUME /opt/robotframework/reports

# Setup X Window Virtual Framebuffer
ENV SCREEN_COLOUR_DEPTH 24
ENV SCREEN_HEIGHT 1080
ENV SCREEN_WIDTH 1920

# Set number of threads for parallel execution
# By default, no parallelisation
ENV ROBOT_THREADS 1

# Dependency versions
ENV CHROMIUM_VERSION 72.0
ENV DATABASE_LIBRARY_VERSION 1.2
ENV FAKER_VERSION 4.2.0
ENV FIREFOX_VERSION 66.0
ENV FTP_LIBRARY_VERSION 1.6
ENV GECKO_DRIVER_VERSION v0.22.0
ENV PABOT_VERSION 0.63
ENV REQUESTS_VERSION 0.5.0
ENV ROBOT_FRAMEWORK_VERSION 3.1.1
ENV SELENIUM_LIBRARY_VERSION 3.3.1
ENV SSH_LIBRARY_VERSION 3.3.0
ENV XVFB_VERSION 1.20

RUN echo '@edge-community http://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories && \
  echo '@edge-testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
  echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories

# Prepare binaries to be executed
COPY bin/chromedriver.sh /opt/robotframework/bin/chromedriver
COPY bin/chromium-browser.sh /opt/robotframework/bin/chromium-browser
COPY bin/run-tests-in-virtual-screen.sh /opt/robotframework/bin/

# Install system dependencies
RUN apk upgrade --no-cache \
  && apk add --no-cache --virtual .build-deps  \
	bzip2-dev \
	dpkg-dev dpkg \
	expat-dev \
	findutils \
	gcc \
	gdbm-dev \
	libc-dev \
	libffi-dev \
	libnsl-dev \
	libtirpc-dev \
	linux-headers \
	make \
	ncurses-dev \
	openssl-dev \
	pax-utils \
	readline-dev \
	sqlite-dev \
	tcl-dev \
	tk \
	tk-dev \
	zlib-dev \
    which \
    wget \
  && apk add --no-cache --update-cache \
    icu-libs@edge \
    firefox@edge-testing=~$FIREFOX_VERSION \
    chromium-chromedriver=~$CHROMIUM_VERSION \
    chromium=~$CHROMIUM_VERSION \
    xauth \
    coreutils \
    xvfb=~$XVFB_VERSION \
  && mv /usr/lib/chromium/chrome /usr/lib/chromium/chrome-original \
  && ln -sfv /opt/robotframework/bin/chromium-browser /usr/lib/chromium/chrome \
# FIXME: above is a workaround, as the path is ignored

# Install Robot Framework and Selenium Library
  && pip install \
  --no-cache-dir \
  robotframework==$ROBOT_FRAMEWORK_VERSION \
  robotframework-databaselibrary==$DATABASE_LIBRARY_VERSION \
  robotframework-faker==$FAKER_VERSION \
  robotframework-ftplibrary==$FTP_LIBRARY_VERSION \
  robotframework-pabot==$PABOT_VERSION \
  robotframework-requests==$REQUESTS_VERSION \
  robotframework-seleniumlibrary==$SELENIUM_LIBRARY_VERSION \
  robotframework-sshlibrary==$SSH_LIBRARY_VERSION \
  PyYAML==5.1 \

# Download Gecko drivers directly from the GitHub repository
  && wget -q "https://github.com/mozilla/geckodriver/releases/download/$GECKO_DRIVER_VERSION/geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz" \
      && tar xzf geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz \
      && mkdir -p /opt/robotframework/drivers/ \
      && mv geckodriver /opt/robotframework/drivers/geckodriver \
      && rm geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz \
  && wget -q "https://raw.githubusercontent.com/cjpetrus/alpine_webkit2png/master/xvfb-run" \
   && mv xvfb-run /usr/bin/xvfb-run \
   && chmod +x /usr/bin/xvfb-run \
  && apk del --no-cache --update-cache .build-deps

# Update system path
ENV PATH=/opt/robotframework/bin:/opt/robotframework/drivers:$PATH

# Execute all robot tests
CMD ["run-tests-in-virtual-screen.sh"]
