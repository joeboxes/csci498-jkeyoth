//PUSH CONSTANT 7
@7
D=A
@SP
A=M
M=D
@SP
M=M+1
//End PUSH
//PUSH CONSTANT 8
@8
D=A
@SP
A=M
M=D
@SP
M=M+1
//End PUSH
//ADD
@SP
AM=M-1
D=M
A=A-1
DM=D+M

//End ADD
