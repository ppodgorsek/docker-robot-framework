FROM fedora:24

MAINTAINER Paul Podgorsek <ppodgorsek@users.noreply.github.com>
LABEL description Robot Framework in Docker.

VOLUME /opt/robotframework/reports
VOLUME /opt/robotframework/tests

RUN dnf upgrade -y\
	&& dnf install -y firefox-49.0-2.fc24\
		java-1.8.0-openjdk\
		python-devel\
		python-setuptools\
		wxPython\
		xorg-x11-server-Xvfb\
	&& dnf clean all

RUN easy_install pip
RUN pip install --upgrade pip
RUN pip install robotframework==3.0
RUN pip install robotframework-selenium2library==1.8.0
RUN pip install robotframework-databaselibrary==0.8.1

COPY bin/firefox.sh /opt/robotframework/bin/firefox

ENV PATH=/opt/robotframework/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENTRYPOINT ["robot", "--outputDir", "/opt/robotframework/reports", "/opt/robotframework/tests"]
