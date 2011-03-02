#!/usr/bin/python
#determine input and output files.

import sys
import os.path as path

#get path to input file from command line arguments
if len(sys.argv) < 2:
	print "Usage: [python] vmCompiler pathToProg.vm [output.asm]"
	exit(1)
inPath = sys.argv[1]



#get the fileName without extension, and the extension from the supplied path
fileName, extension = path.splitext(inPath)

#make sure the supplied file is a .vm file
if extension != ".vm":
	print "Input file must be a .vm file."
	print "Usage: [python] vmCompiler pathToProg.vm [output.asm]"
	exit(1)

#make the output path
 		
 		

if len(sys.argv) == 3:
	outPath = sys.argv[2]
else:
	outPath = fileName + ".asm"

#open the input file. fail nicely if open fails
try:
	inFile = open(inPath)
except:
	print inPath + ": file not found"
	exit(1)

inFile.close()

try:
	outFile = open(outPath, "w")
except:
	print outPath + ": file could not be opened"
	exit(1)