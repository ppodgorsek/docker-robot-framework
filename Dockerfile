FROM fedora:28

MAINTAINER Paul Podgorsek <ppodgorsek@users.noreply.github.com>
LABEL description Robot Framework in Docker.

# Setup volumes for input and output
VOLUME /opt/robotframework/reports
VOLUME /opt/robotframework/tests

# Setup X Window Virtual Framebuffer
ENV SCREEN_COLOUR_DEPTH 24
ENV SCREEN_HEIGHT 1080
ENV SCREEN_WIDTH 1920

# Dependency versions
ENV CHROMIUM_VERSION 67.0.*
ENV FAKER_VERSION 4.2.0
ENV FIREFOX_VERSION 61.0*
ENV GECKO_DRIVER_VERSION v0.19.1
ENV PYTHON_PIP_VERSION 9.0.*
ENV ROBOT_FRAMEWORK_VERSION 3.0.4
ENV SELENIUM_LIBRARY_VERSION 3.1.1
ENV XVFB_VERSION 1.19.*

# Install system dependencies
RUN dnf upgrade -y \
  && dnf install -y \
    chromedriver-$CHROMIUM_VERSION \
    chromium-$CHROMIUM_VERSION \
    firefox-$FIREFOX_VERSION \
    python2-pip-$PYTHON_PIP_VERSION \
    xauth \
    xorg-x11-server-Xvfb-$XVFB_VERSION \
    which \
    wget \
  && dnf clean all

# Install Robot Framework and Selenium Library
RUN pip install \
  robotframework==$ROBOT_FRAMEWORK_VERSION \
  robotframework-faker==$FAKER_VERSION \
  robotframework-seleniumlibrary==$SELENIUM_LIBRARY_VERSION

# Download Gecko drivers directly from the GitHub repository
RUN wget -q "https://github.com/mozilla/geckodriver/releases/download/$GECKO_DRIVER_VERSION/geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz" \
      && tar xzf geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz \
      && mkdir /opt/robotframework/drivers/ \
      && mv geckodriver /opt/robotframework/drivers/geckodriver \
      && rm geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz

# Prepare binaries to be executed
COPY bin/chromedriver.sh /opt/robotframework/bin/chromedriver
COPY bin/chromium-browser.sh /opt/robotframework/bin/chromium-browser
COPY bin/run-tests-in-virtual-screen.sh /opt/robotframework/bin/

# FIXME: below is a workaround, as the path is ignored
RUN mv /usr/lib64/chromium-browser/chromium-browser /usr/lib64/chromium-browser/chromium-browser-original \
  && ln -sfv /opt/robotframework/bin/chromium-browser /usr/lib64/chromium-browser/chromium-browser

# Update system path
ENV PATH=/opt/robotframework/bin:/opt/robotframework/drivers:$PATH

# Execute all robot tests
CMD ["run-tests-in-virtual-screen.sh"]
