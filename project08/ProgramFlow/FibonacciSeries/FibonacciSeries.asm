//PUSH ARGUMENT 1
@ARG
D=M
@1
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
//End PUSH
//POP POINTER 1
@SP
AM=M-1
D=M
@4
M=D
//End POP
//PUSH CONSTANT 0
@0
D=A
@SP
A=M
M=D
@SP
M=M+1
//End PUSH
//POP THAT 0
@THAT
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
//PUSH CONSTANT 1
@1
D=A
@SP
A=M
M=D
@SP
M=M+1
//End PUSH
//POP THAT 1
@THAT
A=M
D=A
@1
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
//PUSH CONSTANT 2
@2
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
(main$MAIN_LOOP_START)
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
//IF-GOTO COMPUTE_ELEMENT
@SP
A=M-1
D=M
@main$COMPUTE_ELEMENT
D;JNE
//End GOTO
//GOTO END_PROGRAM
@main$END_PROGRAM
0;JMP
//End GOTO
(main$COMPUTE_ELEMENT)
//PUSH THAT 0
@THAT
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
//PUSH THAT 1
@THAT
D=M
@1
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
//POP THAT 2
@THAT
A=M
D=A
@2
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
//PUSH POINTER 1
@4
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
//ADD
@SP
AM=M-1
D=M
A=A-1
M=D+M

//End ADD
//POP POINTER 1
@SP
AM=M-1
D=M
@4
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
//GOTO MAIN_LOOP_START
@main$MAIN_LOOP_START
0;JMP
//End GOTO
(main$END_PROGRAM)
(WEAREDONE)
@WEAREDONE
0;JMP
