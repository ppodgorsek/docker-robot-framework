# Robot Framework in Docker, with Firefox and Chrome

## What is it?

This project consists of a Docker image containing a Robot Framework installation.

This installation also contains Firefox, Chrome and the Selenium library for Robot Framework. The test cases and reports should be mounted as volumes.

## Versioning

The versioning of this image follows the one of Robot Framework:

* Major and minor versions match the ones of Robot Framework
* Patch version is specific to this project (allows to update the versions of the other dependencies)

The versions used in the latest version are:

* Robot Framework 3.0.1
* Robot Framework selenium2library 1.8.0
* Firefox 51.0
* Google Chrome 56.0

## Running the container

This container can be run using the following command:

	docker run -v <local path to the reports' folder>:/opt/robotframework/reports:Z -v <local path to the test suites' folder>:/opt/robotframework/tests:Z ppodgorsek/robot-framework:<version>
