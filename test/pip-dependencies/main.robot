# This test scenario was taken from https://github.com/FormulatedAutomation/robotframework-otp

*** Settings ***
Library  OTP
Library  DateTime

*** Variables ***
${SECRET}  base32secret

*** Test Cases ***
Get OTP from secret
    ${otp}=    Get OTP    ${SECRET}
    Log To Console      ${SECRET}
    Should Match Regexp	${otp}	\\d{6}

Get OTP from secret with time
    ${timestamp}=    Convert Date	${1402481262}      epoch
    ${otp}=    Get OTP  ${SECRET}    ${timestamp}
    Should Match Regexp	${otp}	\\d{6}
    Should Be Equal As Strings    ${otp}   055118
