# Robot Framework in Docker, with Firefox and Chrome

## What is it?

This project consists of a Docker image containing a Robot Framework installation.

This installation also contains Firefox, Chrome and the Selenium library for Robot Framework. The test cases and reports should be mounted as volumes.

## Versioning

The versioning of this image follows the one of Robot Framework:

* Major version matches the one of Robot Framework
* Minor and patch versions are specific to this project (allows to update the versions of the other dependencies)

The versions used in the latest version are:

* [Robot Framework](https://github.com/robotframework/robotframework) 3.0.4
* [Robot Framework Faker](https://github.com/guykisel/robotframework-faker) 4.2.0
* [Robot Framework SeleniumLibrary](https://github.com/robotframework/SeleniumLibrary) 3.1.1
* Firefox 61.0
* Chromium 67.0

As stated by [the official GitHub project](https://github.com/robotframework/Selenium2Library), starting from version 3.0, Selenium2Library is renamed to SeleniumLibrary and this project exists mainly to help with transitioning. The Selenium2Library 3.0.0 is also the last release and for new releases, please look at the [SeleniumLibrary](https://github.com/robotframework/SeleniumLibrary) project.

## Running the container

This container can be run using the following command:

    docker run \
        -v <local path to the reports' folder>:/opt/robotframework/reports:Z \
        -v <local path to the test suites' folder>:/opt/robotframework/tests:Z \
        ppodgorsek/robot-framework:<version>

### Switching browsers

Browsers can be easily switched. It is recommended to define `${BROWSER} %{BROWSER}` in your Robot variables and to use `${BROWSER}` in your test cases. This allows to set the browser in a single place if needed.

When running your tests, simply add `-e BROWSER=chrome` or `-e BROWSER=firefox` to the run command.

### Changing the container screen's resolution

It is possible to define the settings of the virtual screen in which the browser is run by changing several environment variables:

* `SCREEN_COLOUR_DEPTH` (default: 24)
* `SCREEN_HEIGHT` (default: 1080)
* `SCREEN_WIDTH` (default: 1920)

### Passing additional options

RobotFramework supports many options such as `--exclude`, `--variable`, `--loglevel`, etc. These can be passed by using the `ROBOT_OPTIONS` environment variable, for example:

    docker run \
        -e ROBOT_OPTIONS="--loglevel DEBUG" \
        ppodgorsek/robot-framework:latest

## Testing this project

Not convinced yet? Simple tests have been prepared in the `test/` folder, you can run them using the following commands:

    # Using Chromium
    docker run \
        -v `pwd`/reports:/opt/robotframework/reports:Z \
        -v `pwd`/test:/opt/robotframework/tests:Z \
        -e BROWSER=chrome \
        ppodgorsek/robot-framework:latest

    # Using Firefox
    docker run \
        -v `pwd`/reports:/opt/robotframework/reports:Z \
        -v `pwd`/test:/opt/robotframework/tests:Z \
        -e BROWSER=firefox \
        ppodgorsek/robot-framework:latest

For Windows users who use **PowerShell**, the commands are slightly different:

    # Using Chromium
    docker run \
        -v ${PWD}/reports:/opt/robotframework/reports:Z \
        -v ${PWD}/test:/opt/robotframework/tests:Z \
        -e BROWSER=chrome \
        ppodgorsek/robot-framework:latest

    # Using Firefox
    docker run \
        -v ${PWD}/reports:/opt/robotframework/reports:Z \
        -v ${PWD}/test:/opt/robotframework/tests:Z \
        -e BROWSER=firefox \
        ppodgorsek/robot-framework:latest

Screenshots of the results will be available in the `reports/` folder.

## Troubleshooting

### Chromium is crashing

Chrome drivers might crash due to the small size of `/dev/shm` in the docker container:
> UnknownError: session deleted because of page crash

This is [a known bug of Chromium](https://bugs.chromium.org/p/chromium/issues/detail?id=715363).

To avoid this error, please change the shm size when starting the container by adding the following parameter: `--shm-size=1g` (or any other size more suited to your tests)

### Accessing the logs

In case further investigation is required, the logs can be accessed by mounting their folder. Simply add the following parameter to your `run` command:

* Linux/Mac: ``-v `pwd`/logs:/var/log:Z``
* Windows: ``-v ${PWD}/logs:/var/log:Z``

## Please contribute!

Have you found an issue? Do you have an idea for an improvement? Feel free to contribute by submitting it [on the GitHub project](https://github.com/ppodgorsek/docker-robot-framework/issues).
