@i
M=1
@sum		//c comment!
M=0		//abcdefghijklmnop
(LOOP)	//b comment()!
@i
D=M
@100
D=D-A
@END
D;JGT
@i
D=M
@sum
M=D+M
@i
M=M+1
@LOOP
0;JMP
(END)
@END
0;JMP
