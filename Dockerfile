FROM fedora:25

MAINTAINER Paul Podgorsek <ppodgorsek@users.noreply.github.com>
LABEL description Robot Framework in Docker.

VOLUME /opt/robotframework/reports
VOLUME /opt/robotframework/tests

COPY dnf/google-chrome.repo /etc/yum.repos.d/google-chrome.repo

RUN dnf upgrade -y\
	&& dnf install -y firefox-50.1.0-1.fc25\
		google-chrome-stable-55.0.2883.87-1\
		python-pip\
		wxPython\
		xorg-x11-server-Xvfb\
	&& dnf clean all

RUN pip install robotframework==3.0\
	robotframework-selenium2library==1.8.0

COPY bin/firefox.sh /opt/robotframework/bin/firefox
COPY bin/google-chrome.sh /opt/robotframework/bin/google-chrome

ENV PATH=/opt/robotframework/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENTRYPOINT ["robot", "--outputDir", "/opt/robotframework/reports", "/opt/robotframework/tests"]
