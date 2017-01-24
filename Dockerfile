FROM fedora:25

MAINTAINER Paul Podgorsek <ppodgorsek@users.noreply.github.com>
LABEL description Robot Framework in Docker.

VOLUME /opt/robotframework/reports
VOLUME /opt/robotframework/tests

COPY dnf/google-chrome.repo /etc/yum.repos.d/google-chrome.repo

RUN dnf upgrade -y\
	&& dnf install -y chromedriver-55.0.2883.87-1.fc25\
		firefox-50.1.0-3.fc25\
		google-chrome-stable-55.0.2883.87-1\
		python-pip-8.1.2-2.fc25\
		xorg-x11-server-Xvfb-1.19.1-2.fc25\
	&& dnf clean all

RUN pip install robotframework==3.0.1\
	robotframework-selenium2library==1.8.0

ADD drivers/geckodriver-v0.13.0-linux64.tar.gz /opt/drivers/

ENV PATH=/opt/drivers:$PATH

ENTRYPOINT ["xvfb-run", "--server-args='-screen 0 1920x1080x24'", "robot", "--outputDir", "/opt/robotframework/reports", "/opt/robotframework/tests"]
