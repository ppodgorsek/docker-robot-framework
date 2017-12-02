*** Settings ***
Library			SeleniumLibrary

*** Variables ***
${BROWSER}		%{BROWSER}

*** Test Cases ***
Visit Google
	Open Browser			http://www.google.com	${BROWSER}
	Capture Page Screenshot
