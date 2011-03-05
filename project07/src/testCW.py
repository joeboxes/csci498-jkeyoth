from CodeWriter import *
cw = CodeWriter("test.asm")
cw.loadAsmTemplates()
cw.writeArithmetic("ADD")
cw.close()
