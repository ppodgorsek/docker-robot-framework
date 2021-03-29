*** Settings ***
Library			Browser

*** Variables ***
${BROWSER}		%{BROWSER}

*** Test Cases ***
Visit Baidu
	New Browser			${BROWSER}	headless=false
	New Page			https://www.baidu.com
	Take Screenshot

Visit Bing
	New Browser			${BROWSER}	headless=false
	New Page			https://www.bing.com
	Take Screenshot

Visit Google
	New Browser			${BROWSER}	headless=false
	New Page			https://www.google.com
	Take Screenshot

Visit Yahoo
	New Browser			${BROWSER}	headless=false
	New Page			https://search.yahoo.com
	Take Screenshot
