#!/usr/bin/python
"""This takes two file names as arguments. The first specifies the code to be multified.
The second specifies the file to append the multified code to. If not specified, prints to stdout

Example of multifying:
F1:
And(a=a, b=b, out=out);

F2:
blah blah blah
...
	Parts:
}
And(a=a[0], b=b[0], out=out[0]);
And(a=a[1], b=b[1], out=out[1]);
...
"""

import sys

fname = sys.argv[1];


real_stdout = sys.stdout


try:
	hdlFname = sys.argv[2];
	hdl = open(hdlFname, "a")
except:
	hdl = sys.stdout;
	
f = open(fname)


lines = []

out = ""
for l in f:
	if len(l) > 2:
		lines.append(l)
		
for i in range(16):
	for l in lines:
		t = l
		a = t.find(",")
		while a != -1:
			t = t[:a] + "[" + str(i) + "]" + t[a:]
			a = t.find(",", a+5)
		a=t.find(")")
		t = t[:a] + "[" + str(i) + "]" + t[a:]
		hdl.write(t)
	hdl.write("\n")

sys.stdout = real_stdout
