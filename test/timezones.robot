*** Settings ***
Force Tags        timezone
Test Timeout      1 minute
Library           DateTimeTZ

*** Test Cases ***
Get Time with Datetime
    ${tz}=    DateTimeTZ.Get Timestamp
    ${utc}=    Get Utc Timestamp
    Should Be Equal As Strings    ${tz}    ${utc}