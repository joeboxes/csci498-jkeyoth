#!/usr/bin/python
"""This takes two file names as arguments. The first specifies the code to be multified.
The second specifies the file to append the multified code to. If not specified, prints to stdout


Example input file:
#File
And(a=a, b=b, out=out);
Or(a=h, b=a, out=temp);
#End file

Outputs to:
#File
And(a=a[0], b=b[0], out=out[0]);
And(a=a[1], b=b[1], out=out[1]);
...
Or(a=h[0], b=a[0], out=temp[0]);
Or(a=h[1], b=a[1], out=temp[1]);
...
#End file
"""

import sys




real_stdout = sys.stdout

if len(sys.argv) == 1:
	print "multibitify v1.0 by Josh Keyoth"
	print "usage: multibitify inFile [outFile]"
	print "Takes an hdl part line and expands it to the 16bit version."
	print "i.e. And(a=a, b=b, out=out); =>"
	print "\tAnd(a=a[0], b=b[0], out=out[0]);"
	print "\tAnd(a=a[1], b=b[1], out=out[1]);"
	print "\t..."
	print "Appends to outFile, or to stdout if no outFile is specified."
	print "See source for example input file."
else:
	fname = sys.argv[1]
	f = open(fname)

	try:
		hdlFname = sys.argv[2];
		hdl = open(hdlFname, "a")
	except:
		hdl = sys.stdout;
	



	lines = []
	
	
	
	for l in f:
		if len(l) > 2:
			lines.append(l)
	
	numLines = len(lines)
	print "Multifying", numLines, "parts!"
	
	for i in range(16):
		cnt = 1
		for l in lines:
			t = l
			a = t.find(",")
			while a != -1:
				t = t[:a] + "[" + str(i) + "]" + t[a:]
				a = t.find(",", a+5)
			if cnt == numLines:
				a=t.find(")")
				t = t[:a] + "[" + str(i) + "]" + t[a:]
			hdl.write("\t" + t)
			cnt = cnt + 1
		if numLines-1:
			hdl.write("\n")

	sys.stdout = real_stdout
	if numLines == 1:
		print "Now go move the squigily bracket (}) in the .hdl and you're good!"
	else:
		print "You may need to edit some things, this script is too stoopid right now for inner connections"
		print "Dont forget your squigily!"
