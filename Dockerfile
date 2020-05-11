FROM python:3.8-alpine3.11

MAINTAINER Paul Podgorsek <ppodgorsek@users.noreply.github.com>
LABEL description Robot Framework in Docker.

# Set the reports directory environment variable
ENV ROBOT_REPORTS_DIR /opt/robotframework/reports

# Set the tests directory environment variable
ENV ROBOT_TESTS_DIR /opt/robotframework/tests

# Set the working directory environment variable
ENV ROBOT_WORK_DIR /opt/robotframework/temp

# Setup X Window Virtual Framebuffer
ENV SCREEN_COLOUR_DEPTH 24
ENV SCREEN_HEIGHT 1080
ENV SCREEN_WIDTH 1920

# Set number of threads for parallel execution
# By default, no parallelisation
ENV ROBOT_THREADS 1

# Define the default user who'll run the tests
ENV ROBOT_UID 1000
ENV ROBOT_GID 1000

# Dependency versions
ENV ALPINE_GLIBC 2.31-r0
ENV CHROMIUM_VERSION 81.0
ENV DATABASE_LIBRARY_VERSION 1.2
ENV FAKER_VERSION 5.0.0
ENV FIREFOX_VERSION 68
ENV FTP_LIBRARY_VERSION 1.9
ENV GECKO_DRIVER_VERSION v0.26.0
ENV IMAP_LIBRARY_VERSION 0.3.6
ENV PABOT_VERSION 1.2.1
ENV REQUESTS_VERSION 0.6.6
ENV ROBOT_FRAMEWORK_VERSION 3.1.2
ENV SELENIUM_LIBRARY_VERSION 4.3.0
ENV SSH_LIBRARY_VERSION 3.4.0
ENV XVFB_VERSION 1.20

# Prepare binaries to be executed
COPY bin/chromedriver.sh /opt/robotframework/bin/chromedriver
COPY bin/chromium-browser.sh /opt/robotframework/bin/chromium-browser
COPY bin/run-tests-in-virtual-screen.sh /opt/robotframework/bin/

# Install system dependencies
RUN apk update \
  && apk --no-cache upgrade \
  && apk --no-cache --virtual .build-deps add \
    gcc \
    libffi-dev \
    linux-headers \
    make \
    musl-dev \
    openssl-dev \
    which \
    wget \
  && apk --no-cache add \
    "chromium~$CHROMIUM_VERSION" \
    "chromium-chromedriver~$CHROMIUM_VERSION" \
    "firefox-esr~$FIREFOX_VERSION" \
    xauth \
    "xvfb-run~$XVFB_VERSION" \
  && mv /usr/lib/chromium/chrome /usr/lib/chromium/chrome-original \
  && ln -sfv /opt/robotframework/bin/chromium-browser /usr/lib/chromium/chrome \
# FIXME: above is a workaround, as the path is ignored

# Install Robot Framework and Selenium Library
  && pip3 install \
    --no-cache-dir \
    robotframework==$ROBOT_FRAMEWORK_VERSION \
    robotframework-databaselibrary==$DATABASE_LIBRARY_VERSION \
    robotframework-faker==$FAKER_VERSION \
    robotframework-ftplibrary==$FTP_LIBRARY_VERSION \
    robotframework-imaplibrary2==$IMAP_LIBRARY_VERSION \
    robotframework-pabot==$PABOT_VERSION \
    robotframework-requests==$REQUESTS_VERSION \
    robotframework-seleniumlibrary==$SELENIUM_LIBRARY_VERSION \
    robotframework-sshlibrary==$SSH_LIBRARY_VERSION \
    PyYAML \

# Download the glibc package for Alpine Linux from its GitHub repository
  && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget -q "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$ALPINE_GLIBC/glibc-$ALPINE_GLIBC.apk" \
    && wget -q "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$ALPINE_GLIBC/glibc-bin-$ALPINE_GLIBC.apk" \
    && apk add glibc-$ALPINE_GLIBC.apk \
    && apk add glibc-bin-$ALPINE_GLIBC.apk \
    && rm glibc-$ALPINE_GLIBC.apk \
    && rm glibc-bin-$ALPINE_GLIBC.apk \
    && rm /etc/apk/keys/sgerrand.rsa.pub \

# Download Gecko drivers directly from the GitHub repository
  && wget -q "https://github.com/mozilla/geckodriver/releases/download/$GECKO_DRIVER_VERSION/geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz" \
    && tar xzf geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz \
    && mkdir -p /opt/robotframework/drivers/ \
    && mv geckodriver /opt/robotframework/drivers/geckodriver \
    && rm geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz \

  && apk del --no-cache --update-cache .build-deps

# Create the default report and work folders with the default user to avoid runtime issues
# These folders are writeable by anyone, to ensure the user can be changed on the command line.
RUN mkdir -p ${ROBOT_REPORTS_DIR} \
  && mkdir -p ${ROBOT_WORK_DIR} \
  && chown ${ROBOT_UID}:${ROBOT_GID} ${ROBOT_REPORTS_DIR} \
  && chown ${ROBOT_UID}:${ROBOT_GID} ${ROBOT_WORK_DIR} \
  && chmod ugo+w ${ROBOT_REPORTS_DIR} ${ROBOT_WORK_DIR}

# Allow any user to write logs
RUN chmod ugo+w /var/log \
  && chown ${ROBOT_UID}:${ROBOT_GID} /var/log

# Update system path
ENV PATH=/opt/robotframework/bin:/opt/robotframework/drivers:$PATH

# Set up a volume for the generated reports
VOLUME ${ROBOT_REPORTS_DIR}

USER ${ROBOT_UID}:${ROBOT_GID}

# A dedicated work folder to allow for the creation of temporary files
WORKDIR ${ROBOT_WORK_DIR}

# Execute all robot tests
CMD ["run-tests-in-virtual-screen.sh"]
