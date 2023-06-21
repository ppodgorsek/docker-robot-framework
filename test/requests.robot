*** Settings ***
Library  Collections
Library  String
Library  RequestsLibrary
Library  OperatingSystem

Suite Teardown  Delete All Sessions

*** Test Cases ***
Get Requests
    [Tags]	get
    Create Session  google			http://www.google.com
    Create Session  bing			https://www.bing.com	verify=True
    ${resp}=  		GET On Session	google					/
    Should Be Equal As Strings		${resp.status_code}		200
    ${resp}=		GET On Session	bing					/
    Should Be Equal As Strings		${resp.status_code}		200
