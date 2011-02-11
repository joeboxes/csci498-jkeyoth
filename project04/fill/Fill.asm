@CURPIX
M=0

(LOOP)
	//Get Keyboard
	@KBD
	D=M
	//Set fill color based on keyboard
	@SETBLACK	//29
	D;JGT
	@SETWHITE	//33
	D;JEQ
	//come back from setting color
	(REENTER)
	//get to current pixel
	@SCREEN
	D=A
	@CURPIX //16
	D=D+M
	//reset curpix to 0 if out of screen memory
	@KBD
	D=D-A
	@RESETCURPIX //37
	D;JEQ
	//come back from resetting curpix
	(REENTER2)
	//get to current pixel again
	@SCREEN
	D=A
	@CURPIX //16
	D=D+M
	@HOLDSPOT //17
	M=D
	//set pixel at screen + curpix to curfill
	@CURFILL //18
	D=M
	@HOLDSPOT //17
	A=M	//HOLDSPOT holds the address of the next pixel to be filled
	M=D
	//inc curpix
	@CURPIX //16
	M=M+1
	//loop back
	@LOOP //0
	0;JMP
	
//set curfill to black
(SETBLACK)
@CURFILL //18
M=0
M=!M
@REENTER
0;JMP

//set curfill to white
(SETWHITE)
@CURFILL
M=0
@REENTER
0;JMP

//set curpix to zero
(RESETCURPIX)
@CURPIX
M=0
@REENTER2
0;JMP
