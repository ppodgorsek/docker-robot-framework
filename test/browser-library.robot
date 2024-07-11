*** Settings ***
Library			Browser

*** Variables ***
# There is a conflict between browser names used by Selenium (using "chrome") and Browser (using "chromium")
# Additionally, the Browser library isn't flexible at all and forbids any branded browser
# See SupportedBrowsers: https://marketsquare.github.io/robotframework-browser/Browser.html#New%20Browser
${BROWSER}		%{BROWSER}

*** Test Cases ***
Visit Bing
	Run Keyword If		"${BROWSER}" == 'chrome' or "${BROWSER}" == 'edge'		New Browser		chromium
	Run Keyword If		"${BROWSER}" != 'chrome' and "${BROWSER}" != 'edge'		New Browser		browser=${BROWSER}
	New Page			https://www.bing.com
	Take Screenshot

Visit Google
	Run Keyword If		"${BROWSER}" == 'chrome' or "${BROWSER}" == 'edge'		New Browser		chromium
	Run Keyword If		"${BROWSER}" != 'chrome' and "${BROWSER}" != 'edge'		New Browser		browser=${BROWSER}
	New Page			https://www.google.com
	Take Screenshot

Visit Yahoo
	Run Keyword If		"${BROWSER}" == 'chrome' or "${BROWSER}" == 'edge'		New Browser		chromium
	Run Keyword If		"${BROWSER}" != 'chrome' and "${BROWSER}" != 'edge'		New Browser		browser=${BROWSER}
	New Page			https://search.yahoo.com
	Take Screenshot
