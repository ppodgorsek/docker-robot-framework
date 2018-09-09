*** Settings ***
Library			RequestsLibrary

*** Test Cases ***
Create Session On Google
    [Tags]    108    RequestsLibrary
	  Create Session    Test-Session    https://www.google.com
