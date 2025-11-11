FROM fedora:42

LABEL authors="Paul Podgorsek"
LABEL description="Robot Framework in Docker"

# This image is intended to be built using one of the following platforms:
# * linux/arm64
# * linux/amd64"

ENV ROBOT_FRAMEWORK_BASE_FOLDER="/opt/robotframework"

# Set the Python dependencies' directory environment variable
ENV ROBOT_DEPENDENCY_DIR="${ROBOT_FRAMEWORK_BASE_FOLDER}/dependencies"

# Set the reports directory environment variable
ENV ROBOT_REPORTS_DIR="${ROBOT_FRAMEWORK_BASE_FOLDER}/reports"

# Set the tests directory environment variable
ENV ROBOT_TESTS_DIR="${ROBOT_FRAMEWORK_BASE_FOLDER}/tests"

# Set the working directory environment variable
ENV ROBOT_WORK_DIR="${ROBOT_FRAMEWORK_BASE_FOLDER}/temp"

# Set the maximum number of rounds to rerun failed tests
ENV ROBOT_RERUN_MAX_ROUNDS=0

# Options to the rebot command when rerunning failed tests
ENV ROBOT_RERUN_REBOT_OPTIONS=""

# Setup X Window Virtual Framebuffer
ENV SCREEN_COLOUR_DEPTH=24
ENV SCREEN_HEIGHT=1080
ENV SCREEN_WIDTH=1920

# Setup the timezone to use, defaults to UTC
ENV TZ="UTC"

# Set number of threads for parallel execution
# By default, no parallelisation
ENV ROBOT_THREADS=1

# Define the default user who'll run the tests
ENV ROBOT_UID=1000
ENV ROBOT_GID=1000

# Dependency versions
ENV AWS_CLI_VERSION="1.42.11"
ENV AXE_SELENIUM_LIBRARY_VERSION="2.1.6"
ENV BROWSER_LIBRARY_VERSION="19.7.0"
ENV CHROME_VERSION="139.0.7258.68"
ENV DATABASE_LIBRARY_VERSION="2.1.4"
ENV DATADRIVER_VERSION="1.11.2"
ENV DATETIMETZ_VERSION="1.0.6"
ENV MICROSOFT_EDGE_VERSION="142.0.3595.65"
ENV FAKER_VERSION="6.0.0"
ENV FIREFOX_VERSION="144.0"
ENV FTP_LIBRARY_VERSION="1.9"
ENV GECKO_DRIVER_VERSION="v0.36.0"
ENV IMAP_LIBRARY_VERSION="0.4.11"
ENV PABOT_VERSION="5.0.0"
ENV REQUESTS_VERSION="0.9.7"
ENV ROBOT_FRAMEWORK_VERSION="7.3.2"
ENV SELENIUM_LIBRARY_VERSION="6.7.1"
ENV SSH_LIBRARY_VERSION="3.8.0"

# By default, no reports are uploaded to AWS S3
ENV AWS_UPLOAD_TO_S3="false"

# Install system dependencies
RUN dnf upgrade -y --refresh \
  && dnf install -y \
    dbus-glib \
    dnf-plugins-core \
    firefox-${FIREFOX_VERSION}* \
    gcc \
    gcc-c++ \
    nodejs \
    npm \
    python3-pip \
    python3-pyyaml \
    tzdata \
    wget \
    xorg-x11-server-Xvfb \
  && dnf clean all

# Install Chrome for Testing
# https://developer.chrome.com/blog/chrome-for-testing/
RUN npx @puppeteer/browsers install chrome@${CHROME_VERSION} \
  && npx @puppeteer/browsers install chromedriver@${CHROME_VERSION}

# Install Robot Framework and associated libraries
RUN pip3 install \
  --no-cache-dir \
  robotframework==$ROBOT_FRAMEWORK_VERSION \
  robotframework-browser==$BROWSER_LIBRARY_VERSION \
  robotframework-databaselibrary==$DATABASE_LIBRARY_VERSION \
  robotframework-datadriver==$DATADRIVER_VERSION \
  robotframework-datadriver[XLS] \
  robotframework-datetime-tz==$DATETIMETZ_VERSION \
  robotframework-faker==$FAKER_VERSION \
  robotframework-ftplibrary==$FTP_LIBRARY_VERSION \
  robotframework-imaplibrary2==$IMAP_LIBRARY_VERSION \
  robotframework-pabot==$PABOT_VERSION \
  robotframework-requests==$REQUESTS_VERSION \
  robotframework-seleniumlibrary==$SELENIUM_LIBRARY_VERSION \
  robotframework-sshlibrary==$SSH_LIBRARY_VERSION \
  axe-selenium-python==$AXE_SELENIUM_LIBRARY_VERSION \
  # Install awscli to be able to upload test reports to AWS S3
  awscli==$AWS_CLI_VERSION

# Gecko drivers
# Download Gecko drivers directly from the GitHub repository
RUN if [ `uname --machine` == "x86_64" ]; \
  then \
    export PLATFORM="linux64"; \
  else \
    export PLATFORM="linux-aarch64"; \
  fi \
  && wget -q "https://github.com/mozilla/geckodriver/releases/download/${GECKO_DRIVER_VERSION}/geckodriver-${GECKO_DRIVER_VERSION}-${PLATFORM}.tar.gz" \
  && tar xzf geckodriver-${GECKO_DRIVER_VERSION}-${PLATFORM}.tar.gz \
  && mkdir -p ${ROBOT_FRAMEWORK_BASE_FOLDER}/drivers/ \
  && mv geckodriver ${ROBOT_FRAMEWORK_BASE_FOLDER}/drivers/geckodriver \
  && rm geckodriver-${GECKO_DRIVER_VERSION}-${PLATFORM}.tar.gz

# Install Microsoft Edge & webdriver
RUN if [ `uname --machine` == "x86_64" ]; \
  then \
    export PLATFORM="linux64"; \
  else \
    echo "Microsoft Edge is not available for Linux ARM."; \
    echo "Please visit the official Microsoft Edge website for more information: https://www.microsoft.com/en-us/edge/business/download"; \
    echo "The Arm developer website is also a useful source: https://learn.arm.com/install-guides/browsers/edge/"; \
    exit 0; \
  fi \
  && rpm --import https://packages.microsoft.com/keys/microsoft.asc \
  && dnf config-manager addrepo --from-repofile=https://packages.microsoft.com/yumrepos/edge/config.repo \
  && dnf install -y \
    microsoft-edge-stable-${MICROSOFT_EDGE_VERSION} \
    zip \
  && wget -q "https://msedgedriver.microsoft.com/${MICROSOFT_EDGE_VERSION}/edgedriver_${PLATFORM}.zip" \
  && unzip edgedriver_${PLATFORM}.zip -d edge \
  && mv edge/msedgedriver ${ROBOT_FRAMEWORK_BASE_FOLDER}/drivers/msedgedriver-original \
  && chmod ugo+x ${ROBOT_FRAMEWORK_BASE_FOLDER}/drivers/msedgedriver-original \
  && rm -Rf edgedriver_${PLATFORM}.zip edge/ \
  # IMPORTANT: don't remove the wget package because it's a dependency of Microsoft Edge
  && dnf remove -y \
    zip \
  && dnf clean all

ENV PATH=/opt/microsoft/msedge:$PATH
ENV "webdriver.edge.driver"="${ROBOT_FRAMEWORK_BASE_FOLDER}/drivers/msedgedriver"

# FIXME: Playright currently doesn't support relying on system browsers, which is why the `--skip-browsers` parameter cannot be used here.
# Additionally, it cannot run fully on any OS due to https://github.com/microsoft/playwright/issues/29559
RUN rfbrowser init chromium firefox

# Prepare binaries to be executed
COPY bin/chromedriver.sh                ${ROBOT_FRAMEWORK_BASE_FOLDER}/drivers/chromedriver
COPY bin/chrome.sh                      ${ROBOT_FRAMEWORK_BASE_FOLDER}/bin/chrome
COPY bin/msedgedriver.sh                ${ROBOT_FRAMEWORK_BASE_FOLDER}/drivers/msedgedriver
COPY bin/run-tests-in-virtual-screen.sh ${ROBOT_FRAMEWORK_BASE_FOLDER}/bin/

# Create the default report and work folders with the default user to avoid runtime issues
# These folders are writeable by anyone, to ensure the user can be changed on the command line.
RUN mkdir -p ${ROBOT_REPORTS_DIR} \
  && mkdir -p ${ROBOT_WORK_DIR} \
  && mkdir -p ${ROBOT_WORK_DIR}/msedge \
  && chown -R ${ROBOT_UID}:${ROBOT_GID} ${ROBOT_REPORTS_DIR} \
  && chown -R ${ROBOT_UID}:${ROBOT_GID} ${ROBOT_WORK_DIR} \
  && chmod -R ugo+w ${ROBOT_REPORTS_DIR} ${ROBOT_WORK_DIR} \
  \
  # Allow any user to run the drivers and write logs
  && chmod ugo+x ${ROBOT_FRAMEWORK_BASE_FOLDER}/drivers \
  && chmod ugo+w /var/log \
  && chown ${ROBOT_UID}:${ROBOT_GID} /var/log \
  \
  # Ensure the directory for Python dependencies exists
  && mkdir -p ${ROBOT_DEPENDENCY_DIR} \
  && chown ${ROBOT_UID}:${ROBOT_GID} ${ROBOT_DEPENDENCY_DIR} \
  && chmod 777 ${ROBOT_DEPENDENCY_DIR}

# Update system path
ENV PATH=${ROBOT_FRAMEWORK_BASE_FOLDER}/bin:${ROBOT_FRAMEWORK_BASE_FOLDER}/drivers:$PATH

# Set up a volume for the generated reports
VOLUME ${ROBOT_REPORTS_DIR}

USER ${ROBOT_UID}:${ROBOT_GID}

# A dedicated work folder to allow for the creation of temporary files
WORKDIR ${ROBOT_WORK_DIR}

# Execute all robot tests
CMD ["run-tests-in-virtual-screen.sh"]
