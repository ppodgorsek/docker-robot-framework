*** Settings ***
Library			SeleniumLibrary

*** Variables ***
${BROWSER}		%{BROWSER}

*** Test Cases ***
Verify WebGl
	Open Browser			https://browserleaks.com/webgl		${BROWSER}
	Element Should Contain	id:webgl1_status	True
	Capture Page Screenshot
