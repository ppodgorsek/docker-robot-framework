*** Settings ***
Force Tags        timezone
Test Timeout      1 minute
Library           DateTimeTZ

*** Test Cases ***
Get Time with Datetime
    ${utc}=    Get Unix Time
    ${tz}=    Convert Timestamp Format    ${utc}    time_format=dd LLL y H:mm:ss
    Log    ${tz}
    Log    ${utc}