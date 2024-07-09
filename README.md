# Robot Framework in Docker, with Firefox, Chrome and Microsoft Edge

## Table of contents

* [What is it?](#what-is-it)
* [Versioning](#versioning)
* [Running the container](#running-the-container)
    * [Switching browsers](#switching-browsers)
    * [Changing the container's screen resolution](#changing-the-containers-screen-resolution)
    * [Changing the container's tests and reports directories](#changing-the-containers-tests-and-reports-directories)
    * [Parallelisation](#parallelisation)
        * [Parallelisation options](#parallelisation-options)
    * [Passing additional options](#passing-additional-options)
    * [Testing emails](#testing-emails)
    * [Dealing with Datetimes and Timezones](#dealing-with-datetimes-and-timezones)
    * [Installing additional dependencies](#installing-additional-dependencies)
* [Security consideration](#security-consideration)
* [Continuous integration](#continuous-integration)
    * [Defining a test run ID](#defining-a-test-run-id)
    * [Upload test reports to an AWS S3 bucket](#upload-test-reports-to-an-aws-s3-bucket)
* [Testing this project](#testing-this-project)
* [Troubleshooting](#troubleshooting)
    * [Chromium is crashing](#chromium-is-crashing)
    * [Accessing the logs](#accessing-the-logs)
    * [Error: Suite contains no tests](#error-suite-contains-no-tests)
    * [Database tests are failing in spite of the DatabaseLibrary being present](#database-tests-are-failing-in-spite-of-the-databaselibrary-being-present)
    * [Supported devices and architectures](#supported-devices-and-architectures)
* [Please contribute!](#please-contribute)

-----

<a name="what-is-it"></a>

## What is it?

This project consists of a container image containing a Robot Framework installation.

This installation also contains Firefox, Chrome, Microsoft Edge, along with the Selenium and Playwright/RFBrowser library for Robot Framework.

<a name="versioning"></a>

## Versioning

The versioning of this image follows the one of Robot Framework:

* Major version matches the one of Robot Framework
* Minor and patch versions are specific to this project (allows to update the versions of the other dependencies)

The versions used are:

* [Robot Framework](https://github.com/robotframework/robotframework) 7.0.1
* [Robot Framework Browser (Playwright) Library](https://github.com/MarketSquare/robotframework-browser) 18.6.3
* [Robot Framework DatabaseLibrary](https://github.com/franz-see/Robotframework-Database-Library) 1.4.4
* [Robot Framework Datadriver](https://github.com/Snooz82/robotframework-datadriver) 1.11.2
* [Robot Framework DateTimeTZ](https://github.com/testautomation/DateTimeTZ) 1.0.6
* [Robot Framework Faker](https://github.com/guykisel/robotframework-faker) 5.0.0
* [Robot Framework FTPLibrary](https://github.com/kowalpy/Robot-Framework-FTP-Library) 1.9
* [Robot Framework IMAPLibrary 2](https://pypi.org/project/robotframework-imaplibrary2/) 0.4.6
* [Robot Framework Pabot](https://github.com/mkorpela/pabot) 2.18.0
* [Robot Framework Requests](https://github.com/bulkan/robotframework-requests) 0.9.7
* [Robot Framework SeleniumLibrary](https://github.com/robotframework/SeleniumLibrary) 6.4.0
* [Robot Framework SSHLibrary](https://github.com/robotframework/SSHLibrary) 3.8.0
* [Axe Selenium Library](https://github.com/mozilla-services/axe-selenium-python) 2.1.6
* Firefox 123.0
* Chromium 122.0
* Microsoft Edge 121.0.2277.106
* [Amazon AWS CLI](https://pypi.org/project/awscli/) 1.33.23

As stated by [the official GitHub project](https://github.com/robotframework/Selenium2Library), starting from version 3.0, Selenium2Library is renamed to SeleniumLibrary and this project exists mainly to help with transitioning. The Selenium2Library 3.0.0 is also the last release and for new releases, please look at the [SeleniumLibrary](https://github.com/robotframework/SeleniumLibrary) project.

<a name="running-the-container"></a>

## Running the container

This container can be run using the following command:

    docker run \
        -v <local path to the reports' folder>:/opt/robotframework/reports:Z \
        -v <local path to the test suites' folder>:/opt/robotframework/tests:Z \
        ppodgorsek/robot-framework:<version>

<a name="switching-browsers"></a>

### Switching browsers

Browsers can be easily switched. It is recommended to define `${BROWSER} %{BROWSER}` in your Robot variables and to use `${BROWSER}` in your test cases. This allows to set the browser in a single place if needed.

When running your tests, simply add `-e BROWSER=chrome`, `-e BROWSER=firefox` or `-e BROWSER=edge`to the run command.

Please note: `edge` will work with Selenium but not the Browser Library, as the latter currently doesn't have an easy mechanism to install additional browsers. Playwright, on which the Browser library relies, cannot install additional browsers on Linux platforms other than Ubuntu/Debian and [suggests using Chromium to test Microsoft Edge scenarios](https://playwright.dev/docs/browsers), unless you require Edge-specific capabilities.

<a name="changing-the-containers-screen-resolution"></a>

### Changing the container's screen resolution

It is possible to define the settings of the virtual screen in which the browser is run by changing several environment variables:

* `SCREEN_COLOUR_DEPTH` (default: 24)
* `SCREEN_HEIGHT` (default: 1080)
* `SCREEN_WIDTH` (default: 1920)

<a name="changing-the-containers-tests-and-reports-directories"></a>

### Changing the container's tests and reports directories

It is possible to use different directories to read tests from and to generate reports to. This is useful when using a complex test file structure. To change the defaults, set the following environment variables:

* `ROBOT_REPORTS_DIR` (default: /opt/robotframework/reports)
* `ROBOT_TESTS_DIR` (default: /opt/robotframework/tests)

<a name="parallelisation"></a>

### Parallelisation

It is possible to parallelise the execution of your test suites. Simply define the `ROBOT_THREADS` environment variable, for example:

    docker run \
        -e ROBOT_THREADS=4 \
        ppodgorsek/robot-framework:latest

By default, there is no parallelisation.

<a name="parallelisation-options"></a>

#### Parallelisation options

When using parallelisation, it is possible to pass additional [pabot options](https://github.com/mkorpela/pabot#command-line-options), such as `--testlevelsplit`, `--argumentfile`, `--ordering`, etc. These can be passed by using the `PABOT_OPTIONS` environment variable, for example:

    docker run \
        -e ROBOT_THREADS=4 \
        -e PABOT_OPTIONS="--testlevelsplit" \
        ppodgorsek/robot-framework:latest

<a name="passing-additional-options"></a>

### Passing additional options

RobotFramework supports many options such as `--exclude`, `--variable`, `--loglevel`, etc. These can be passed by using the `ROBOT_OPTIONS` environment variable, for example:

    docker run \
        -e ROBOT_OPTIONS="--loglevel DEBUG" \
        ppodgorsek/robot-framework:latest

<a name="testing-emails"></a>

### Testing emails

This project includes the IMAP library which allows Robot Framework to connect to email servers.

A suggestion to automate email testing is to run a [Mailcatcher instance in Docker which allows IMAP connections](https://github.com/estelora/docker-mailcatcher-imap). This will ensure emails are discarded once the tests have been run.

<a name="dealing-with-datetimes-and-timezones"></a>

### Dealing with Datetimes and Timezones

This project is meant to allow your tests to run anywhere. Sometimes that can be in a different timezone than your local one or of the location under test. To help solve such issues, this image includes the [DateTimeTZ Library](https://testautomation.github.io/DateTimeTZ/doc/DateTimeTZ.html).

To set the timezone used inside the Docker image, you can set the `TZ` environment variable:

    docker run \
        -e TZ=America/New_York \
        ppodgorsek/robot-framework:latest

<a name="installing-additional-dependencies"></a>

### Installing additional dependencies

It is possible to install additional dependencies dynamically at runtime rather than having to extend this image.

To do so, simply mount a text file containing the list of dependencies you would like to install using `pip`: (by default, this file is empty if not mounted)

    docker run \
        -v <local path to the dependency file>:/opt/robotframework/pip-requirements.txt:Z \
        -v <local path to the test suites' folder>:/opt/robotframework/tests:Z \
        ppodgorsek/robot-framework:latest

The file must follow [Pip's official requirements file format](https://pip.pypa.io/en/stable/reference/requirements-file-format/).

Here is a example of what such a file could contain:

```
robotframework-docker==1.4.2
rpa==1.50.0
```

**For large dependencies, it is still recommended to extend the project's image and to add them there, to avoid delaying the CI/CD pipelines with repeated dependency installations.**

<a name="security-considerations"></a>

## Security consideration

By default, containers are implicitly run using `--user=1000:1000`, please remember to adjust that command-line setting accordingly, for example:

    docker run \
        --user=1001:1001 \
        ppodgorsek/robot-framework:latest

Remember that that UID/GID should be allowed to access the mounted volumes in order to read the test suites and to write the output.

Additionally, it is possible to rely on user namespaces to further secure the execution. This is well described in the official container documentation:

* Docker: [Introduction to User Namespaces in Docker Engine](https://success.docker.com/article/introduction-to-user-namespaces-in-docker-engine)
* Podman: [Running rootless Podman as a non-root user](https://www.redhat.com/sysadmin/rootless-podman-makes-sense)

This is a good security practice to make sure containers cannot perform unwanted changes on the host. In that sense, Podman is probably well ahead of Docker by not relying on a root daemon to run its containers.

<a name="continuous-integration"></a>

## Continuous integration

It is possible to run the project from within a Jenkins pipeline by relying on the shell command line directly:

    pipeline {
        agent any
        stages {
            stage('Functional regression tests') {
                steps {
                    sh "docker run --shm-size=1g -e BROWSER=firefox -v $WORKSPACE/robot-tests:/opt/robotframework/tests:Z -v $WORKSPACE/robot-reports:/opt/robotframework/reports:Z ppodgorsek/robot-framework:latest"
                }
            }
        }
    }

The pipeline stage can also rely on a Docker agent, as shown in the example below:

    pipeline {
        agent none
        stages {
            stage('Functional regression tests') {
                agent { docker {
                    image 'ppodgorsek/robot-framework:latest'
                    args '--shm-size=1g -u root' }
                }
                environment {
                    BROWSER = 'firefox'
                    ROBOT_TESTS_DIR = "$WORKSPACE/robot-tests"
                    ROBOT_REPORTS_DIR = "$WORKSPACE/robot-reports"
                }
                steps {
                    sh '''
                        /opt/robotframework/bin/run-tests-in-virtual-screen.sh
                    '''
                }
            }
        }
    }

<a name="defining-a-test-run-id"></a>

### Defining a test run ID

When relying on Continuous Integration tools, it can be useful to define a test run ID such as the build number or branch name to avoid overwriting consecutive execution reports.

For that purpose, the `ROBOT_TEST_RUN_ID` variable was introduced:
* If the test run ID is empty, the reports folder will be: `${ROBOT_REPORTS_DIR}/`
* If the test run ID was provided, the reports folder will be: `${ROBOT_REPORTS_DIR}/${ROBOT_TEST_RUN_ID}/`

It can simply be passed during the execution, such as:

    docker run \
        -e ROBOT_TEST_RUN_ID="feature/branch-name" \
        ppodgorsek/robot-framework:latest

By default, the test run ID is empty.

<a name="upload-test-reports-to-an-aws-s3-bucket"></a>

### Upload test reports to an AWS S3 bucket

To upload the report of a test run to an S3 bucket, you need to define the following environment variables:

    docker run \
        -e AWS_ACCESS_KEY_ID=<your AWS key> \
        -e AWS_SECRET_ACCESS_KEY=<your AWS secret> \
        -e AWS_DEFAULT_REGION=<your AWS region e.g. eu-central-1> \
        -e AWS_BUCKET_NAME=<name of your S3 bucket> \
        ppodgorsek/robot-framework:latest

<a name="testing-this-project"></a>

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

<a name="troubleshooting"></a>

## Troubleshooting

<a name="chromium-is-crashing"></a>

### Chromium is crashing

Chrome drivers might crash due to the small size of `/dev/shm` in the docker container:

> UnknownError: session deleted because of page crash

This is [a known bug of Chromium](https://bugs.chromium.org/p/chromium/issues/detail?id=715363).

To avoid this error, please change the shm size when starting the container by adding the following parameter: `--shm-size=1g` (or any other size more suited to your tests)

<a name="accessing-the-logs"></a>

### Accessing the logs

In case further investigation is required, the logs can be accessed by mounting their folder. Simply add the following parameter to your `run` command:

* Linux/Mac: ``-v `pwd`/logs:/var/log:Z``
* Windows: ``-v ${PWD}/logs:/var/log:Z``

Chromium allows to set additional environment properties, which can be useful when debugging:

* `webdriver.chrome.verboseLogging=true`: enables the verbose logging mode
* `webdriver.chrome.logfile=/path/to/chromedriver.log`: sets the path to Chromium's log file

<a name="error-suite-contains-no-tests"></a>

### Error: Suite contains no tests

When running tests, an unexpected error sometimes occurs:

> [Error] Suite contains no tests.

There are two main causes to this:
* Either the test folder is not the right one,
* Or the permissions on the test folder/test files are too restrictive.

As there can sometimes be issues as to where the tests are run from, make sure the correct folder is used by trying the following actions:
* Use a full path to the folder instead of a relative one,
* Replace any`` `pwd` ``or `${PWD}` by the full path to the folder.

It is also important to check if Robot Framework is allowed to access the resources it needs, i.e.:
* The folder where the tests are located,
* The test files themselves.

<a name="database-tests-are-failing-in-spite-of-the-databaselibrary-being-present"></a>

### Database tests are failing in spite of the DatabaseLibrary being present

As per their official project page, the [Robot Framework DatabaseLibrary](https://github.com/franz-see/Robotframework-Database-Library) contains utilities meant for Robot Framework's usage. This can allow you to query your database after an action has been made to verify the results. This is compatible with any Database API Specification 2.0 module.

It is anyway mandatory to extend the container image to install the specific database module relevant to your tests, such as:
* [MS SQL](https://pymssql.readthedocs.io/en/latest/intro.html): `pip install pymssql`
* [MySQL](https://dev.mysql.com/downloads/connector/python/): `pip install pymysql`
* [Oracle](https://www.oracle.com/uk/database/technologies/appdev/python.html): `pip install py2oracle`
* [PostgreSQL](http://pybrary.net/pg8000/index.html): `pip install pg8000`

<a name="supported-devices-and-architectures"></a>

### Supported devices and architectures

As mentioned on the [Docker Hub](https://hub.docker.com/r/ppodgorsek/robot-framework), the project has been built and uploaded as a `linux/amd64` image only. This means ARM devices such as MacBook M1/M2 and Amazon EC2 Graviton won't be able to run the image with the default configuration.

As mentioned in the official documentation, [Podman](https://docs.podman.io/en/latest/markdown/podman-run.1.html#platform-os-arch) and [Docker](https://docs.docker.com/build/building/multi-platform/) provide a `--platform` option which selects a given application architecture, such as:

    docker run \
        --platform linux/amd64 \
        -v <local path to the reports' folder>:/opt/robotframework/reports:Z \
        -v <local path to the test suites' folder>:/opt/robotframework/tests:Z \
        ppodgorsek/robot-framework:<version>

Please note: builds and automated tests of this project will remain performed on a `linux/amd64` architecture so such emulation might not work, depending on your device and operating system.

If this does not solve your platform-related issues, you will have to rebuild the image for your device/platform, specifying that `--platform` option during the build and run.

<a name="please-contribute"></a>

## Please contribute!

Have you found an issue? Do you have an idea for an improvement? Feel free to contribute by submitting it [on the GitHub project](https://github.com/ppodgorsek/docker-robot-framework/issues).
