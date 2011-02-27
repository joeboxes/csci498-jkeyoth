#!/usr/bin/python

from Parser import *


#test A commands
p = Parser("testACom.asm")

print "=====Testing A commands"

if p.advance() == 1:
	print "advance returns 1 when expected 0"

comType = p.commandType()
if comType != A_COMMAND:
	print "wrong command type returned:", comType

sym = p.symbol()
if sym != "i":
	print "wrong symbol returned. Expected i, got:", sym

p.advance()
sym = p.symbol()
if sym != "LOOP":
	print "wrong symbol returned. Expected LOOP, got:", sym

p.advance()
sym = p.symbol()
if sym != "1234":
	print "wrong symbol returned. Expected 1234, got:", sym

if p.hasMoreCommands():
	print "hasMoreCommands returns true when expected false"

if p.advance() == 0:
	print "advance returns 0 when expected 1"

print "done testing A commands====="
p.advance()

#test L commands
print "=====Testing L commands"

p = Parser("testLCom.asm")

p.advance()

comType = p.commandType()
if comType != L_COMMAND:
	print "wrong command type returned:", comType

sym = p.symbol()
if sym != "TEST":
	print "wrong symbol returned. Expected TEST, got:", sym
	
p.advance()
sym = p.symbol()
if sym != "END":
	print "wrong symbol returned. Expected END, got:", sym

print "done testing L commands====="

#Test C commands
print "=====Testing C commands"

def testC(parser,exD,exC,exJ):
	"""Test a C command to see if the return values of
	dest(), comp(), and jump() match the expected ones"""
	d = parser.dest()
	c = parser.comp()
	j = parser.jump()
	if d != exD:
		print parser.commands[parser.curCommand],"dest did not match. Got:",d,". Expected:",exD
	if c != exC:
		print parser.commands[parser.curCommand],"comp did not match. Got:",c,". Expected:",exC
	if j != exJ:
		print parser.commands[parser.curCommand],"jump did not match. Got:",j,". Expected:",exJ

p = Parser("testCCom.asm")

p.advance()

comType = p.commandType()
if comType != C_COMMAND:
	print "wrong command type returned:", comType

testC(p,"D","1",None)
p.advance()
testC(p,None,"D",None)
p.advance()
testC(p,None,"A+1",None)
p.advance()
testC(p,None,"D&M",None)
p.advance()
testC(p,"A","D+A",None)
p.advance()
testC(p,"AD","D+A",None)
p.advance()
testC(p,"D","M-D","JEQ")
p.advance()
testC(p,"A","M","JLT")
p.advance()
testC(p,None,"D","JGE")
p.advance()
testC(p,None,"0","JMP")
