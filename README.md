# Robot Framework in Docker, with Firefox and Chrome

## What is it?

This project consists of a Docker image containing a Robot Framework installation.

This installation also contains Firefox, Chrome and the Selenium library for Robot Framework. The test cases and reports should be mounted as volumes.

## Versioning

The versioning of this image follows the one of Robot Framework:

* Major and minor versions match the ones of Robot Framework
* Patch version is specific to this project (allows to update the versions of the other dependencies)

The versions used in the latest version are:

* Robot Framework 3.0.2
* Robot Framework selenium2library 1.8.0
* Firefox 57.0
* Chromium 62.0

## Running the container

This container can be run using the following command:

    docker run -v <local path to the reports' folder>:/opt/robotframework/reports:Z\
        -v <local path to the test suites' folder>:/opt/robotframework/tests:Z\
        ppodgorsek/robot-framework:<version>

### Switching browsers

Browsers can be easily switched. It is recommended to define `${BROWSER} %{BROWSER}` in your Robot variables and to use `${BROWSER}` in your test cases. This allows to set the browser in a single place if needed.

When running your tests, simply add `-e BROWSER=chrome` or `-e BROWSER=firefox` to the run command.

### Changing the container screen's resolution

It is possible to define the settings of the virtual screen in which the browser is run by changing several environment variables:

* `SCREEN_COLOUR_DEPTH` (default: 24)
* `SCREEN_HEIGHT` (default: 1080)
* `SCREEN_WIDTH` (default: 1920)
