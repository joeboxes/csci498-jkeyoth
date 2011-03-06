#!/usr/bin/python

from CodeWriter import *
cw = CodeWriter("test.asm")
cw.writePushPop("PUSH", "CONSTANT", 3)
cw.close()
