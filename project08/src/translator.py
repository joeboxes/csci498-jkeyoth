#!/usr/bin/python
#determine input and output files.

import sys
import os.path as path
from os import listdir as lsdir
from Parser import Parser
from CodeWriter import CodeWriter

#get path to input file from command line arguments
if len(sys.argv) < 2:
	print "Usage: [python] vmCompiler pathToProg.vm [output.asm]"
	exit(1)
inPath = sys.argv[1]

vmNames = []

if path.isdir(inPath):
	fileName = inPath
	
	for f in lsdir(inPath):
		if path.splitext(f)[1] == ".vm":
			vmNames.append(inPath + "/" + f)
	print vmNames
else:
	#get the fileName without extension, and the extension from the supplied path
	fileName, extension = path.splitext(inPath)
	
	#make sure the supplied file is a .vm file
	if extension != ".vm":
		print "Input file must be a .vm file."
		print "Usage: [python] vmCompiler pathToProg.vm [output.asm]"
		exit(1)
	
	vmNames.append(inPath)
	
#make the output path	

if len(sys.argv) == 3:
	outPath = sys.argv[2]
else:
	outPath = fileName + ".asm"

#open the input file. fail nicely if open fails
for f in vmNames:
	try:
		inFile = open(f)
	except:
		print f + ": file not found"
		exit(1)
	
	inFile.close()

#open output file, fail nicely if it fails
try:
	outFile = open(outPath, "w")
	
except:
	print outPath + ": file could not be opened"
	exit(1)
finally:
	outFile.close()



writer = CodeWriter(outPath)

for f in vmNames:
	fn = path.basename(f)
	print "Working on:",fn
	writer.setFileName(fn)
	parser = Parser(f)
	while parser.hasMoreCommands():
		parser.advance()
		if parser.commandType() == "C_ARITHMETIC":
			writer.writeArithmetic(parser.arg1())
		elif parser.commandType() == "C_PUSH":
			writer.writePushPop("PUSH", parser.arg1(), parser.arg2())
		elif parser.commandType() == "C_POP":
			writer.writePushPop("POP", parser.arg1(), parser.arg2())
		elif parser.commandType() == "C_LABEL":
			writer.writeLabel(parser.arg1())
		elif parser.commandType() == "C_GOTO" or parser.commandType() == "C_IF-GOTO":
			writer.writeGoto(parser.commandType()[2:], parser.arg1())
		else:
			print "Command not supported:",parser.commandType()
			
writer.close()
print inPath,"=>",outPath
			