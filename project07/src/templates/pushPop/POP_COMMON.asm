@${segment}		//POP ${segment} ${index}
A=M
D=A
@${index}
D=D+A
@5
M=D
@SP
AM=M-1
D=M
@5
A=M
M=D				//End POP ${segment} ${index}
