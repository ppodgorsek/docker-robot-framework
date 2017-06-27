FROM fedora:25

MAINTAINER Paul Podgorsek <ppodgorsek@users.noreply.github.com>
LABEL description Robot Framework in Docker.

VOLUME /opt/robotframework/reports
VOLUME /opt/robotframework/tests

COPY dnf/google-chrome.repo /etc/yum.repos.d/google-chrome.repo

RUN dnf upgrade -y\
	&& dnf install -y\
		chromedriver-59.0.3071.104-1.fc25\
		firefox-54.0-2.fc25\
		google-chrome-stable-59.0.3071.115-1\
		python-pip-8.1.2-2.fc25\
		xorg-x11-server-Xvfb-1.19.3-1.fc25\
	&& dnf clean all

RUN pip install robotframework==3.0.2\
	robotframework-selenium2library==1.8.0

ADD drivers/geckodriver-v0.13.0-linux64.tar.gz /opt/robotframework/drivers/

COPY bin/google-chrome.sh /opt/robotframework/bin/google-chrome

# FIXME: below is a workaround, as the path is ignored
RUN mv /opt/google/chrome/google-chrome /opt/google/chrome/google-chrome-original\
	&& ln -sfv /opt/robotframework/bin/google-chrome /opt/google/chrome/google-chrome

ENV PATH=/opt/robotframework/bin:/opt/robotframework/drivers:$PATH

ENTRYPOINT ["xvfb-run", "--server-args=-screen 0 1920x1080x24 -ac", "robot", "--outputDir", "/opt/robotframework/reports", "/opt/robotframework/tests"]
