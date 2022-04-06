*** Settings ***
Force Tags        timezone
Test Timeout      1 minute
Library           DateTimeTZ

*** Test Cases ***
Get Time with Datetime
    ${ts}=    Get Timestamp
    Set Test Message	${ts}