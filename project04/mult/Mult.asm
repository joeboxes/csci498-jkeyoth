@R2
M=0
(LOOP)
@R0
D=M
@END
D;JLE
@R2
D=M
@R1
D=D+M
@R2
M=D
@R0
M=M-1
@LOOP
0;JMP

(END)
@END
0;JMP
