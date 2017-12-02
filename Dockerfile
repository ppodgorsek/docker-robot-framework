FROM fedora:26

MAINTAINER Paul Podgorsek <ppodgorsek@users.noreply.github.com>
LABEL description Robot Framework in Docker.

VOLUME /opt/robotframework/reports
VOLUME /opt/robotframework/tests

ENV SCREEN_COLOUR_DEPTH 24
ENV SCREEN_HEIGHT 1080
ENV SCREEN_WIDTH 1920

RUN dnf upgrade -y\
	&& dnf install -y\
		chromedriver-61.0.3163.100-1.fc26\
		chromium-61.0.3163.100-1.fc26\
		firefox-57.0-2.fc26\
		python2-pip-9.0.1-9.fc26\
		xorg-x11-server-Xvfb-1.19.3-4.fc26\
		which-2.21-2.fc26\
	&& dnf clean all

RUN pip install robotframework==3.0.2\
	robotframework-selenium2library==1.8.0

ADD drivers/geckodriver-v0.18.0-linux64.tar.gz /opt/robotframework/drivers/

COPY bin/chromedriver.sh /opt/robotframework/bin/chromedriver
COPY bin/chromium-browser.sh /opt/robotframework/bin/chromium-browser

# FIXME: below is a workaround, as the path is ignored
RUN mv /usr/lib64/chromium-browser/chromium-browser /usr/lib64/chromium-browser/chromium-browser-original\
	&& ln -sfv /opt/robotframework/bin/chromium-browser /usr/lib64/chromium-browser/chromium-browser

ENV PATH=/opt/robotframework/bin:/opt/robotframework/drivers:$PATH

ENTRYPOINT ["xvfb-run", "--server-args=-screen 0 ${SCREEN_HEIGHT}x${SCREEN_WIDTH}x${SCREEN_COLOUR_DEPTH} -ac", "robot", "--outputDir", "/opt/robotframework/reports", "/opt/robotframework/tests"]
