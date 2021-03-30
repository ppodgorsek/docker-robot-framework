*** Settings ***
Library			Browser

*** Variables ***
# There is a conflict between browser names used by Selenium (using "chrome") and Browser (using "chromium")
# This is why the browser is currently fixed for the Browser Library.
${BROWSER}		firefox

*** Test Cases ***
Visit Bing
	New Browser			${BROWSER}
	New Page			https://www.bing.com
	Take Screenshot

Visit Google
	New Browser			${BROWSER}
	New Page			https://www.google.com
	Take Screenshot

Visit Yahoo
	New Browser			${BROWSER}
	New Page			https://search.yahoo.com
	Take Screenshot
