@${segment}		//PUSH ${segment} ${index}
D=M
@${index}
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1			//End PUSH ${segment} ${index}
