(SIMPLEFUNCTION.TEST)
@0//PUSH_CONST
D=A
@SP
A=M
M=D
@SP
M=M+1
@0//PUSH_CONST
D=A
@SP
A=M
M=D
@SP
M=M+1
@LCL//PUSH_COMMON
D=M
@0
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
@LCL//PUSH_COMMON
D=M
@1
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
@SP//ADD
AM=M-1
D=M
A=A-1
M=D+M
@SP//NOT
A=M-1
M=!M
@ARG//PUSH_COMMON
D=M
@0
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
@SP//ADD
AM=M-1
D=M
A=A-1
M=D+M
@ARG//PUSH_COMMON
D=M
@1
A=D+A
D=M
@SP
A=M
M=D
@SP
M=M+1
@SP//SUB
AM=M-1
D=M
A=A-1
M=M-D
//RETURNING
@LCL//PUSH_DIRECT
D=M
@SP
A=M
M=D
@SP
M=M+1
@SP//POP_DIRECT
AM=M-1
D=M
@6
M=D
@6//PUSH_DIRECT
D=M
@SP
A=M
M=D
@SP
M=M+1
@5//PUSH_CONST
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP//SUB
AM=M-1
D=M
A=A-1
M=M-D
@SP//POP_DIRECT
AM=M-1
D=M
@7
M=D
@ARG//POP_COM
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
@ARG//PUSH_DIRECT
D=M
@SP
A=M
M=D
@SP
M=M+1
@1//PUSH_CONST
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP//ADD
AM=M-1
D=M
A=A-1
M=D+M
@SP//POP_DIRECT
AM=M-1
D=M
@SP
M=D
@6//PUSH_DIRECT
D=M
@SP
A=M
M=D
@SP
M=M+1
@1//PUSH_CONST
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP//SUB
AM=M-1
D=M
A=A-1
M=M-D
@SP//POP_DIRECT
AM=M-1
D=M
@8
M=D
@8
D=M
@4
M=D
@6//PUSH_DIRECT
D=M
@SP
A=M
M=D
@SP
M=M+1
@2//PUSH_CONST
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP//SUB
AM=M-1
D=M
A=A-1
M=M-D
@SP//POP_DIRECT
AM=M-1
D=M
@8
M=D
@8
D=M
@3
M=D
@6//PUSH_DIRECT
D=M
@SP
A=M
M=D
@SP
M=M+1
@3//PUSH_CONST
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP//SUB
AM=M-1
D=M
A=A-1
M=M-D
@SP//POP_DIRECT
AM=M-1
D=M
@8
M=D
@8
D=M
@2
M=D
@6//PUSH_DIRECT
D=M
@SP
A=M
M=D
@SP
M=M+1
@4//PUSH_CONST
D=A
@SP
A=M
M=D
@SP
M=M+1
@SP//SUB
AM=M-1
D=M
A=A-1
M=M-D
@SP//POP_DIRECT
AM=M-1
D=M
@8
M=D
@8
D=M
@1
M=D
@7
A=M
0;JMP
