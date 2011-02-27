#!/usr/bin/python

import sys
import os.path as path
from Parser import *
import Code
from SymbolTable import SymbolTable

#determine input and output files.

#get path to input file from command line arguments
if len(sys.argv) < 2:
	print "Usage: [python] assembler pathToAsm.asm"
	exit(1)
inPath = sys.argv[1]



#get the fileName without extension, and the extension from the supplied path
fileName, extension = path.splitext(inPath)

#make sure the supplied file is a .asm file
if extension != ".asm":
	print "Input file must be a .asm file."
	print "Usage: [python] assembler pathToAsm.asm"
	exit(1)

#make the output path

if len(sys.argv) == 3:
	outPath = sys.argv[2]
else:
	outPath = fileName + ".hack"

#open the input file. fail nicely if open fails
try:
	inFile = open(inPath)
except:
	print inPath + ": file not found"

inFile.close()

try:
	outFile = open(outPath, "w")
except:
	print outPath + ": file could not be opened"


#init parser and symbolTable
parser = Parser(inPath)

symbolTable = SymbolTable()

#pass 0
i = 0
while parser.hasMoreCommands():
	parser.advance()
	
	if parser.commandType() == "L":
		symbolTable.addEntry(parser.symbol(), i)
	else:
		i += 1

#pass 1
parser.reset()

while parser.hasMoreCommands():
	parser.advance()
	
	type = parser.commandType()
	
	if type == "A":
		sym = parser.symbol()
		#sym is a constant
		if ord(sym[0]) >= ord("0") and ord(sym[0]) <= ord("9"):
			outFile.write("0" + Code.decimalConstantToBinaryString(sym) + "\n")
		#sym is in table
		elif symbolTable.contains(sym):
			outFile.write("0" + symbolTable.getAddress(sym) + "\n")
		#sym is a new var
		else:
			symbolTable.addVariable(sym)
			outFile.write("0" + symbolTable.getAddress(sym) + "\n")
		
	elif type == "C":
		d = Code.dest(parser.dest())
		c = Code.comp(parser.comp())
		j = Code.jump(parser.jump())
		outFile.write("111" + c + d + j + "\n")

outFile.close()
		
		
			




