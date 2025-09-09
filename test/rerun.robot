*** Test Cases ***

Roll Dice 1
    ${rand}=    Evaluate    random.randint(1,6) 
	IF    ${rand} > 1
        Fail
	END

Roll Dice 2
    ${rand}=    Evaluate    random.randint(1,6) 
	IF    ${rand} > 1
        Fail
	END

Roll Dice 3
    ${rand}=    Evaluate    random.randint(1,6) 
	IF    ${rand} > 1
        Fail
	END

Roll Dice 4
    ${rand}=    Evaluate    random.randint(1,6) 
	IF    ${rand} > 1
        Fail
	END