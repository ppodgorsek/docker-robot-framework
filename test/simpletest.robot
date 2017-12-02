*** Settings ***
Library			Selenium2Library

*** Variables ***
${BROWSER}		%{BROWSER}

*** Test Cases ***
Visit Google
	Open Browser			http://www.google.com	${BROWSER}
	Capture Page Screenshot
