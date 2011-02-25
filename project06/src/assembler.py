#!/usr/bin/python

import sys
import os.path as path

#determine input and output files.

#get path to input file from command line arguments
if len(sys.argv) != 2:
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
outPath = fileName + ".hack"

#open the input file. fail nicely if open fails
try:
	inFile = open(inPath)
except:
	print inPath + ": file not found"

outFile = open(outPath, "w")

outFile.write("TEST\n")

