# Robot Framework in Docker, with Firefox and Chrome

## What is it?

This project consists of a Docker image containing a Robot Framework installation.

This installation also contains Firefox, Chrome and the Selenium library for Robot Framework. The test cases and reports should be mounted as volumes.

## Versioning

The versioning of this image follows the one of Robot Framework:

* Major version matches the one of Robot Framework
* Minor and patch versions are specific to this project (allows to update the versions of the other dependencies)

The versions used in the latest version are:

* Robot Framework 3.0.2
* Robot Framework SeleniumLibrary 3.0.0
* Firefox 57.0
* Chromium 63.0

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

## Testing this project

Not convinced yet? Simple tests have been prepared in the `test/` folder, you can run them using the following command:

    docker run -v ./test:/opt/robotframework/tests:Z\
        ppodgorsek/robot-framework:latest

## Please contribute!

Have you found an issue? Do you have an idea for an improvement? Feel free to contribute by submitting it [on the GitHub project](https://github.com/ppodgorsek/docker-robot-framework/issues).

