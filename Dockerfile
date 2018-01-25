FROM fedora:27

MAINTAINER Paul Podgorsek <ppodgorsek@users.noreply.github.com>
LABEL description Robot Framework in Docker.

VOLUME /opt/robotframework/reports
VOLUME /opt/robotframework/tests

ENV SCREEN_COLOUR_DEPTH 24
ENV SCREEN_HEIGHT 1080
ENV SCREEN_WIDTH 1920

RUN dnf upgrade -y\
	&& dnf install -y\
		chromedriver-63.0.*\
		chromium-63.0.*\
		firefox-57.0-*\
		python2-pip-9.0.1-*\
		xorg-x11-server-Xvfb-1.19.*\
	&& dnf clean all

RUN pip install robotframework==3.0.2\
	robotframework-seleniumlibrary==3.0.1

ADD drivers/geckodriver-v0.19.1-linux64.tar.gz /opt/robotframework/drivers/

COPY bin/chromedriver.sh /opt/robotframework/bin/chromedriver
COPY bin/chromium-browser.sh /opt/robotframework/bin/chromium-browser
COPY bin/run-tests-in-virtual-screen.sh /opt/robotframework/bin/

# FIXME: below is a workaround, as the path is ignored
RUN mv /usr/lib64/chromium-browser/chromium-browser /usr/lib64/chromium-browser/chromium-browser-original\
	&& ln -sfv /opt/robotframework/bin/chromium-browser /usr/lib64/chromium-browser/chromium-browser

ENV PATH=/opt/robotframework/bin:/opt/robotframework/drivers:$PATH

CMD ["run-tests-in-virtual-screen.sh"]
