*** Settings ***
Library  Collections
Library  String
Library  RequestsLibrary
Library  OperatingSystem

Suite Teardown  Delete All Sessions

*** Test Cases ***
Get Requests
    [Tags]  get
    Create Session  google  http://www.google.com
    Create Session  bing  https://www.bing.com   verify=True
    ${resp}=  Get Request  google  /
    Should Be Equal As Strings  ${resp.status_code}  200
    ${resp}=  Get Request  bing  /
    Should Be Equal As Strings  ${resp.status_code}  200

Get Requests with Url Parameters
    [Tags]  get
    Create Session  httpbin     http://httpbin.org
    &{params}=   Create Dictionary   key=value     key2=value2
    ${resp}=     Get Request  httpbin  /get    params=${params}
    Should Be Equal As Strings  ${resp.status_code}  200
    ${jsondata}=  To Json  ${resp.content}
    Should Be Equal     ${jsondata['args']}     ${params}

Get HTTPS & Verify Cert
    [Tags]  get     get-cert
    Create Session    httpbin    https://httpbin.org   verify=True
    ${resp}=  Get Request  httpbin  /get
    Should Be Equal As Strings  ${resp.status_code}  200

Post Request With URL Params
    [Tags]  post
    Create Session  httpbin  http://httpbin.org
    &{params}=   Create Dictionary   key=value     key2=value2
    ${resp}=  Post Request  httpbin  /post		params=${params}
    Should Be Equal As Strings  ${resp.status_code}  200

Post Request With No Data
    [Tags]  post
    Create Session  httpbin  http://httpbin.org
    ${resp}=  Post Request  httpbin  /post  
    Should Be Equal As Strings  ${resp.status_code}  200

Put Request With No Data
    [Tags]  put
    Create Session  httpbin  http://httpbin.org
    ${resp}=  Put Request  httpbin  /put
    Should Be Equal As Strings  ${resp.status_code}  200

Post Request With No Dictionary
    [Tags]  post
    Create Session  httpbin  http://httpbin.org    debug=3
    Set Test Variable  ${data}  some content
    ${resp}=  Post Request  httpbin  /post  data=${data}
    Should Be Equal As Strings  ${resp.status_code}  200
    Should Contain  ${resp.text}  ${data}

Put Request With URL Params
    [Tags]  put
    Create Session  httpbin  http://httpbin.org
    &{params}=   Create Dictionary   key=value     key2=value2
    ${resp}=  Put Request  httpbin  /put  params=${params}
    Should Be Equal As Strings  ${resp.status_code}  200

Put Request With No Dictionary
    [Tags]  put
    Create Session  httpbin  http://httpbin.org
    Set Test Variable  ${data}  some content
    ${resp}=  Put Request  httpbin  /put  data=${data}
    Should Be Equal As Strings  ${resp.status_code}  200
    Should Contain  ${resp.text}  ${data}

Post Requests
    [Tags]  post
    Create Session  httpbin  http://httpbin.org
    &{data}=  Create Dictionary  name=bulkan  surname=evcimen
    &{headers}=  Create Dictionary  Content-Type=application/x-www-form-urlencoded
    ${resp}=  Post Request  httpbin  /post  data=${data}  headers=${headers}
    Dictionary Should Contain Value  ${resp.json()['form']}  bulkan
    Dictionary Should Contain Value  ${resp.json()['form']}  evcimen

Post With Unicode Data
    [Tags]  post
    Create Session  httpbin  http://httpbin.org    debug=3
    &{data}=  Create Dictionary  name=度假村
    &{headers}=  Create Dictionary  Content-Type=application/x-www-form-urlencoded
    ${resp}=  Post Request  httpbin  /post  data=${data}  headers=${headers}
    Dictionary Should Contain Value  ${resp.json()['form']}  度假村

Post Request With Unicode Data
    [Tags]  post
    Create Session  httpbin  http://httpbin.org    debug=3
    &{data}=  Create Dictionary  name=度假村
    &{headers}=  Create Dictionary  Content-Type=application/x-www-form-urlencoded
    ${resp}=  Post Request  httpbin  /post  data=${data}  headers=${headers}
    Dictionary Should Contain Value  ${resp.json()['form']}  度假村

Post Request With Data and File
    [Tags]    post
    Create Session    httpbin    http://httpbin.org
    &{data}=    Create Dictionary    name=mallikarjunarao    surname=kosuri
    Create File    foobar.txt    content=foobar
    ${file_data}=    Get File    foobar.txt
    &{files}=    Create Dictionary    file=${file_data}
    ${resp}=    Post Request    httpbin    /post    files=${files}    data=${data}
    Should Be Equal As Strings    ${resp.status_code}    200

Put Requests
    [Tags]  put
    Create Session  httpbin  http://httpbin.org
    &{data}=  Create Dictionary  name=bulkan  surname=evcimen
    &{headers}=  Create Dictionary  Content-Type=application/x-www-form-urlencoded
    ${resp}=  Put Request  httpbin  /put  data=${data}  headers=${headers}
    Dictionary Should Contain Value  ${resp.json()['form']}  bulkan
    Dictionary Should Contain Value  ${resp.json()['form']}  evcimen

Head Request
    [Tags]  head
    Create Session  httpbin  http://httpbin.org
    ${resp}=  Head Request  httpbin  /headers
    Should Be Equal As Strings  ${resp.status_code}  200

Options Request
    [Tags]  options
    Create Session  httpbin  http://httpbin.org
    ${resp}=  Options Request  httpbin  /headers
    Should Be Equal As Strings  ${resp.status_code}  200
    Dictionary Should Contain Key  ${resp.headers}  allow

Delete Request With URL Params
    [Tags]  delete
    Create Session  httpbin  http://httpbin.org
    &{params}=   Create Dictionary   key=value     key2=value2
    ${resp}=  Delete Request  httpbin  /delete		${params}
    Should Be Equal As Strings  ${resp.status_code}  200

Delete Request With No Data
    [Tags]  delete
    Create Session  httpbin  http://httpbin.org
    ${resp}=  Delete Request  httpbin  /delete
    Should Be Equal As Strings  ${resp.status_code}  200

Delete Request With Data
    [Tags]  delete
    Create Session  httpbin  http://httpbin.org    debug=3
    &{data}=  Create Dictionary  name=bulkan  surname=evcimen
    ${resp}=  Delete Request  httpbin  /delete  data=${data}
    Should Be Equal As Strings  ${resp.status_code}  200
    Log  ${resp.content}
    Comment  Dictionary Should Contain Value  ${resp.json()['data']}  bulkan
    Comment  Dictionary Should Contain Value  ${resp.json()['data']}  evcimen

Patch Requests
    [Tags]    patch
    Create Session    httpbin    http://httpbin.org
    &{data}=    Create Dictionary    name=bulkan    surname=evcimen
    &{headers}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${resp}=    Patch Request    httpbin    /patch    data=${data}    headers=${headers}
    Dictionary Should Contain Value    ${resp.json()['form']}    bulkan
    Dictionary Should Contain Value    ${resp.json()['form']}    evcimen

Get Request With Redirection
    [Tags]  get
    Create Session  httpbin  http://httpbin.org    debug=3
    ${resp}=  Get Request  httpbin  /redirect/1
    Should Be Equal As Strings  ${resp.status_code}  200
    ${resp}=  Get Request  httpbin  /redirect/1  allow_redirects=${true}
    Should Be Equal As Strings  ${resp.status_code}  200

Get Request Without Redirection
    [Tags]  get
    Create Session  httpbin  http://httpbin.org
    ${resp}=  Get Request  httpbin  /redirect/1  allow_redirects=${false}
    ${status}=  Convert To String  ${resp.status_code}
    Should Start With  ${status}  30

Options Request With Redirection
    [Tags]  options
    Create Session  httpbin  http://httpbin.org
    ${resp}=  Options Request  httpbin  /redirect/1
    Should Be Equal As Strings  ${resp.status_code}  200
    ${resp}=  Options Request  httpbin  /redirect/1  allow_redirects=${true}
    Should Be Equal As Strings  ${resp.status_code}  200

Head Request With Redirection
    [Tags]  head
    Create Session  httpbin  http://httpbin.org
    ${resp}=  Head Request  httpbin  /redirect/1  allow_redirects=${true}
    Should Be Equal As Strings  ${resp.status_code}  200

Head Request Without Redirection
    [Tags]  head
    Create Session  httpbin  http://httpbin.org
    ${resp}=  Head Request  httpbin  /redirect/1
    ${status}=  Convert To String  ${resp.status_code}
    Should Start With  ${status}  30
    ${resp}=  Head Request  httpbin  /redirect/1  allow_redirects=${false}
    ${status}=  Convert To String  ${resp.status_code}
    Should Start With  ${status}  30

Post Request With Redirection
    [Tags]  post
    Create Session  jigsaw  http://jigsaw.w3.org
    ${resp}=  Post Request  jigsaw  /HTTP/300/302.html
    Should Be Equal As Strings  ${resp.status_code}  200
    ${resp}=  Post Request  jigsaw  /HTTP/300/302.html  allow_redirects=${true}
    Should Be Equal As Strings  ${resp.status_code}  200

Post Request Without Redirection
    [Tags]  post
    Create Session  jigsaw  http://jigsaw.w3.org    debug=3
    ${resp}=  Post Request  jigsaw  /HTTP/300/302.html  allow_redirects=${false}
    ${status}=  Convert To String  ${resp.status_code}
    Should Start With  ${status}  30

Put Request With Redirection
    [Tags]  put
    Create Session  jigsaw  http://jigsaw.w3.org    debug=3
    ${resp}=  Put Request  jigsaw  /HTTP/300/302.html
    Should Be Equal As Strings  ${resp.status_code}  200
    ${resp}=  Put Request  jigsaw  /HTTP/300/302.html  allow_redirects=${true}
    Should Be Equal As Strings  ${resp.status_code}  200

Put Request Without Redirection
    [Tags]  put
    Create Session  jigsaw  http://jigsaw.w3.org
    ${resp}=  Put Request  jigsaw  /HTTP/300/302.html  allow_redirects=${false}
    ${status}=  Convert To String  ${resp.status_code}
    Should Start With  ${status}  30

Do Not Pretty Print a JSON object
    [Tags]    json
    Comment    Define json variable.
    &{var}=    Create Dictionary    key_one=true    key_two=this is a test string
    ${resp}=    Get Request    httpbin    /get    params=${var}
    Set Suite Variable    ${resp}
    Should Be Equal As Strings    ${resp.status_code}    200
    ${jsondata}=    To Json    ${resp.content}
    Dictionaries Should Be Equal   ${jsondata['args']}    ${var}

Pretty Print a JSON object
    [Tags]    json
    Comment    Define json variable.
    Log    ${resp}
    ${output}=    To Json    ${resp.content}    pretty_print=True
    Log    ${output}
    Should Contain    ${output}    "key_one": "true"
    Should Contain    ${output}    "key_two": "this is a test string"
    Should Not Contain    ${output}    {u'key_two': u'this is a test string', u'key_one': u'true'}

Set Pretty Print to non-Boolean value
    [Tags]    json
    Comment    Define json variable.
    Log    ${resp}
    ${output}=    To Json    ${resp.content}    pretty_print="Hello"
    Log    ${output}
    Should Contain    ${output}    "key_one": "true"
    Should Contain    ${output}    "key_two": "this is a test string"
    Should Not Contain    ${output}    {u'key_two': u'this is a test string', u'key_one': u'true'}
