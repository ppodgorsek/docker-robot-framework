*** Test Cases ***

Randomly Fail Test
    ${rand}=    Evaluate    random.randint(0,3) 
	IF    ${rand} > 0
        Fail
	END