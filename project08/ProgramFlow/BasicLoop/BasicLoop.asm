//PUSH CONSTANT 0
@0
D=A
@SP
A=M
M=D
@SP
M=M+1
//End PUSH
//POP LOCAL 0
@LCL
A=M
D=A
@0
D=D+A
@5
M=D
@SP
AM=M-1
D=M
@5
A=M
M=D
//End POP
(main$LOOP_START)
//PUSH ARGUMENT 0
@ARG
D=M
@0
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
//End PUSH
//PUSH LOCAL 0
@LCL
D=M
@0
A=D+A
D=M
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
M=D+M

//End ADD
//POP LOCAL 0
@LCL
A=M
D=A
@0
D=D+A
@5
M=D
@SP
AM=M-1
D=M
@5
A=M
M=D
//End POP
//PUSH ARGUMENT 0
@ARG
D=M
@0
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
//End PUSH
//PUSH CONSTANT 1
@1
D=A
@SP
A=M
M=D
@SP
M=M+1
//End PUSH
//SUB
@SP
AM=M-1
D=M
A=A-1
M=M-D

//End SUB
//POP ARGUMENT 0
@ARG
A=M
D=A
@0
D=D+A
@5
M=D
@SP
AM=M-1
D=M
@5
A=M
M=D
//End POP
//PUSH ARGUMENT 0
@ARG
D=M
@0
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
//End PUSH
//IF-GOTO LOOP_START
@SP
AM=M-1
D=M
@main$LOOP_START
D;JNE
//End GOTO
//PUSH LOCAL 0
@LCL
D=M
@0
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
//End PUSH
(WEAREDONE)
@WEAREDONE
0;JMP
