*** Settings ***
Force Tags        faker
Test Timeout      1 minute
Library           FakerLibrary

*** Test Cases ***
Can Get Fake Name
    ${name}=    FakerLibrary.Name
    Should Not Be Empty    ${name}

Two Calls To Faker Should Give Different Results
    ${name}=    FakerLibrary.Name
    Should Not Be Empty    ${name}
    ${name2}=    FakerLibrary.Name
    Should Not Be Empty    ${name2}
    Should Not Be Equal As Strings    ${name}    ${name2}

Can call Words with integer argument
    ${WordsList}=    Words    nb=${10}
    Log    ${WordsList}
    Length Should Be    ${WordsList}    10

Can call Words with str integer argument
    ${WordsList}=    Words    nb=10
    Log    ${WordsList}
    Length Should Be    ${WordsList}    10

Can call SHA-1
    SHA1
    SHA1    ${True}
    SHA1    ${False}
    SHA1    True
    SHA1    False

Can Lexify
    ${lexed}=    Lexify    blah???
    Length Should Be    ${lexed}    7
    Should Start With    ${lexed}    blah

Can call Password
    ${pass}=    Password
    Length Should Be    ${pass}    10
    ${pass}=    Password    ${5}
    Length Should Be    ${pass}    5
    ${pass}=    Password    5
    Length Should Be    ${pass}    5
    ${pass}=    Password    special_chars=${False}
    ${pass}=    Password    special_chars=${True}
    ${pass}=    Password    digits=${True}
    ${pass}=    Password    digits=${False}
    ${pass}=    Password    digits=True
    ${pass}=    Password    digits=False
    ${pass}=    Password    upper_case=${True}
    ${pass}=    Password    lower_case=${True}
    ${pass}=    Password    digits=${False}
    ${pass}=    Password    5823    ${True}    ${False}    ${True}    ${True}
    Length Should Be    ${pass}    5823
    ${pass}=    Password    ${5823}    ${True}    ${False}    ${True}    ${True}
    Length Should Be    ${pass}    5823