@SP
AM=M-1
D=M
A=A-1
D=M-D
@LT_LESS${num}
D;JLT
@LT_NOTLESS${num}
D;JGE
(LT_LESS${num})
@SP
A=M-1
M=-1
@LT_END${num}
0;JMP
(LT_NOTLESS${num})
@SP
A=M-1
M=0
@LT_END${num}
0;JMP
(LT_END${num})