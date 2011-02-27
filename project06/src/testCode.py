from Parser import *
import Code

def testC(p,exD,exC,exJ):
	d = p.dest()
	c = p.comp()
	j = p.jump()
	
	print d,c,j
	
	dbin = Code.dest(d)
	cbin = Code.comp(c)
	jbin = Code.jump(j)
	
	if dbin != exD:
		print "Dest binary does not match. Expected:",exD,"Got:",dbin
	if cbin != exC:
		print "Comp binary does not match. Expected:",exC,"Got:",cbin
	if jbin != exJ:
		print "Jump binary does not match. Expected:",exJ,"Got:",jbin
		
	return "111" + cbin + dbin + jbin


#test C command binary conversions from Code.py
#not exhaustive

print "=====Testing C command binary conversion"

p = Parser("testCCom.asm")

print "D=1"
p.advance()
print testC(p,"010","0111111","000")

print "D"
p.advance()
print testC(p,"000","0001100","000")

print "A+1"
p.advance()
print testC(p,"000","0110111","000")

print "D&M"
p.advance()
print testC(p,"000","1000000","000")

print "A=D+A"
p.advance()
print testC(p,"100","0000010","000")

print "AD=D+A"
p.advance()
print testC(p,"110","0000010","000")

print "D=M-D;JEQ"
p.advance()
print testC(p,"010","1000111","010")

print "A=M;JLT"
p.advance()
print testC(p,"100","1110000","100")

print "D;JGE"
p.advance()
print testC(p,"000","0001100","011")

print "0;JMP"
p.advance()
print testC(p,"000","0101010","111")

print "done testing C====="

print "=====Testing decimalConstantToBinaryString"

binary = Code.decimalConstantToBinaryString("33")

if binary != "000000000100001":
	print "Bad conversion. Got:",binary,"Expected: 000000000100001"

binary = Code.decimalConstantToBinaryString("267")

if binary != "000000100001011":
	print "Bad conversion. Got:",binary,"Expected: 000000100001011"

print "done testing decimalConstantToBinaryString====="
