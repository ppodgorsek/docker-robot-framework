*** Settings ***
Library         SeleniumLibrary
Test Teardown   Close All Browsers

*** Variables ***
${BROWSER}		%{BROWSER}

*** Test Cases ***
Visit Bing
	Open Browser			https://www.bing.com		${BROWSER}
	Capture Page Screenshot

Visit Google
	Open Browser			https://www.google.com		${BROWSER}
	Capture Page Screenshot
