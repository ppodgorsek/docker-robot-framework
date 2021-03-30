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

Get Requests with Url Parameters
    [Tags]	get
    Create Session	httpbin				http://httpbin.org
    &{params}=		Create Dictionary	key=value				key2=value2
    ${resp}=		GET On Session		httpbin					/get		params=${params}
    Should Be Equal As Strings			${resp.status_code}		200
    Should Be Equal						${resp.json()['args']}	${params}

Get HTTPS & Verify Cert
    [Tags]	get get-cert
    Create Session	httpbin			https://httpbin.org		verify=True
    ${resp}=		GET On Session	httpbin					/get
    Should Be Equal As Strings		${resp.status_code}		200

Post Request With URL Params
    [Tags]	post
    Create Session	httpbin				http://httpbin.org
    &{params}=		Create Dictionary	key=value			key2=value2
    ${resp}=		POST On Session		httpbin				/post		params=${params}
    Should Be Equal As Strings			${resp.status_code}	200

Post Request With No Data
    [Tags]	post
    Create Session	httpbin				http://httpbin.org
    ${resp}=		POST On Session		httpbin				/post  
    Should Be Equal As Strings			${resp.status_code}	200

Put Request With No Data
    [Tags]	put
    Create Session	httpbin			http://httpbin.org
    ${resp}=		PUT On Session	httpbin				/put
    Should Be Equal As Strings		${resp.status_code}	200

Post Request With No Dictionary
    [Tags]	post
    Create Session		httpbin			http://httpbin.org	debug=3
    Set Test Variable	${data}			some content
    ${resp}=			POST On Session	httpbin				/post	data=${data}
    Should Be Equal As Strings			${resp.status_code}	200
    Should Contain						${resp.text}		${data}

Put Request With URL Params
    [Tags]	put
    Create Session	httpbin				http://httpbin.org
    &{params}=		Create Dictionary	key=value	key2=value2
    ${resp}=		PUT On Session		httpbin		/put		params=${params}
    Should Be Equal As Strings			${resp.status_code}		200

Put Request With No Dictionary
    [Tags]	put
    Create Session		httpbin			http://httpbin.org
    Set Test Variable					${data}				some content
    ${resp}=			PUT On Session	httpbin				/put			data=${data}
    Should Be Equal As Strings			${resp.status_code}	200
    Should Contain						${resp.text}		${data}

Post Requests
    [Tags]	post
    Create Session	httpbin				http://httpbin.org
    &{data}=		Create Dictionary	name=bulkan				surname=evcimen
    &{headers}=		Create Dictionary	Content-Type=application/x-www-form-urlencoded
    ${resp}=		POST On Session		httpbin					/post			data=${data}	headers=${headers}
    Dictionary Should Contain Value		${resp.json()['form']}  bulkan
    Dictionary Should Contain Value		${resp.json()['form']}  evcimen

Post With Unicode Data
    [Tags]	post
    Create Session	httpbin				http://httpbin.org		debug=3
    &{data}=		Create Dictionary	name=度假村
    &{headers}=		Create Dictionary	Content-Type=application/x-www-form-urlencoded
    ${resp}=		POST On Session		httpbin					/post		data=${data}	headers=${headers}
    Dictionary Should Contain Value		${resp.json()['form']}	度假村

Post Request With Unicode Data
    [Tags]	post
    Create Session	httpbin				http://httpbin.org		debug=3
    &{data}=		Create Dictionary	name=度假村
    &{headers}=		Create Dictionary	Content-Type=application/x-www-form-urlencoded
    ${resp}=		POST On Session		httpbin					/post	data=${data}	headers=${headers}
    Dictionary Should Contain Value		${resp.json()['form']}	度假村

Post Request With Data and File
    [Tags]	post
    Create Session	httpbin				http://httpbin.org
    &{data}=		Create Dictionary	name=mallikarjunarao	surname=kosuri
    Create File		foobar.txt			content=foobar
    ${file_data}=	Get File			foobar.txt
    &{files}=		Create Dictionary	file=${file_data}
    ${resp}=		POST On Session		httpbin					/post	files=${files}	data=${data}
    Should Be Equal As Strings			${resp.status_code}		200

Put Requests
    [Tags]	put
    Create Session	httpbin				http://httpbin.org
    &{data}=		Create Dictionary	name=bulkan				surname=evcimen
    &{headers}=		Create Dictionary	Content-Type=application/x-www-form-urlencoded
    ${resp}=		PUT On Session		httpbin					/put	data=${data}	headers=${headers}
    Dictionary Should Contain Value		${resp.json()['form']}	bulkan
    Dictionary Should Contain Value		${resp.json()['form']}	evcimen

Head Request
    [Tags]	head
    Create Session	httpbin				http://httpbin.org
    ${resp}=		HEAD On Session		httpbin				/headers
    Should Be Equal As Strings			${resp.status_code}	200

Options Request
    [Tags]	options
    Create Session	httpbin				http://httpbin.org
    ${resp}=		OPTIONS On Session	httpbin				/headers
    Should Be Equal As Strings			${resp.status_code}	200
    Dictionary Should Contain Key		${resp.headers}		allow

Delete Request With URL Params
    [Tags]	delete
    Create Session	httpbin				http://httpbin.org
    ${resp}=		DELETE On Session	httpbin				url=/delete?key=value&key2=value2
    Should Be Equal As Strings			${resp.status_code}	200

Delete Request With No Data
    [Tags]	delete
    Create Session	httpbin				http://httpbin.org
    ${resp}=		DELETE On Session	httpbin				/delete
    Should Be Equal As Strings			${resp.status_code}	200

Delete Request With Data
    [Tags]	delete
    Create Session	httpbin				http://httpbin.org	debug=3
    &{data}=		Create Dictionary	name=bulkan			surname=evcimen
    ${resp}=		DELETE On Session	httpbin				/delete			data=${data}
    Should Be Equal As Strings			${resp.status_code}	200
    Log				${resp.content}
    Comment			Dictionary Should Contain Value  ${resp.json()['data']}  bulkan
    Comment			Dictionary Should Contain Value  ${resp.json()['data']}  evcimen

Patch Requests
    [Tags]	patch
    Create Session	httpbin				http://httpbin.org
    &{data}=		Create Dictionary	name=bulkan				surname=evcimen
    &{headers}=		Create Dictionary	Content-Type=application/x-www-form-urlencoded
    ${resp}=		PATCH On Session    httpbin					/patch			data=${data}	headers=${headers}
    Dictionary Should Contain Value		${resp.json()['form']}	bulkan
    Dictionary Should Contain Value		${resp.json()['form']}	evcimen

Post Request With Redirection
    [Tags]	post
    Create Session	jigsaw				http://jigsaw.w3.org
    ${resp}=		POST On Session		jigsaw					/HTTP/300/302.html
    Should Be Equal As Strings			${resp.status_code}		200
    ${resp}=		POST On Session		jigsaw					/HTTP/300/302.html	allow_redirects=${true}
    Should Be Equal As Strings			${resp.status_code}		200

Post Request Without Redirection
    [Tags]	post
    Create Session	jigsaw				http://jigsaw.w3.org	debug=3
    ${resp}=		POST On Session		jigsaw					/HTTP/300/302.html	allow_redirects=${false}
    ${status}=		Convert To String	${resp.status_code}
    Should Start With					${status}				30

Put Request With Redirection
    [Tags]	put
    Create Session	jigsaw				http://jigsaw.w3.org	debug=3
    ${resp}=		PUT On Session		jigsaw					/HTTP/300/302.html
    Should Be Equal As Strings			${resp.status_code}		200
    ${resp}=		PUT On Session		jigsaw					/HTTP/300/302.html	allow_redirects=${true}
    Should Be Equal As Strings			${resp.status_code}		200

Put Request Without Redirection
    [Tags]	put
    Create Session	jigsaw				http://jigsaw.w3.org
    ${resp}=		PUT On Session		jigsaw					/HTTP/300/302.html	allow_redirects=${false}
    ${status}=		Convert To String	${resp.status_code}
    Should Start With					${status}				30

Do Not Pretty Print a JSON object
    [Tags]	json
    Comment			Define json variable.
    Create Session	httpbin					http://httpbin.org
    &{var}=			Create Dictionary		key_one=true			key_two=this is a test string
    ${resp}=		GET On Session			httpbin					/get			params=${var}
    Should Be Equal As Strings				${resp.status_code}		200
    Dictionaries Should Be Equal			${resp.json()['args']}	${var}
