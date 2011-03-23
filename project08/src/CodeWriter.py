
from Cheetah.Template import Template
import os.path as path

class CodeWriter:
	"""Write code"""
	
	arithmeticTempNames = ["ADD", "SUB", "NEG", "EQ", "GT", "LT", "AND", "OR", "NOT"]
	
	pushPopTempNames = ["POP_COMMON", "POP_CONSTANT", "POP_STATIC", "POP_DIRECT", "PUSH_COMMON", \
					"PUSH_CONSTANT", "PUSH_STATIC", "PUSH_DIRECT"]
	
	commonSegments = ["LOCAL", "ARGUMENT", "THIS", "THAT"]
	
	
	
	segmentTranslation = {"LOCAL" : "LCL", "ARGUMENT" : "ARG", "THIS" : "THIS", "THAT" : "THAT"}
	
	def __init__(self, outName):
		self.outFile = open(outName, "w")
		self.loadArithTemplates()
		self.loadPushPopTemplates()
		self.loadFlowTemplates()
		self.functName = "main"
		self.labelCounter = 0
	
	def writeInit(self):
		"""write the bootstrap code"""
		#TODO: implement
	
	def loadArithTemplates(self):
		"""load the template file for each arithmetic command"""
		self.arithmeticTemplates = dict()
		for cmd in self.arithmeticTempNames:
			tmpFile = open("templates/arithmetic/" + cmd + ".asm")
			self.arithmeticTemplates[cmd] = ""
			for c in tmpFile:
				self.arithmeticTemplates[cmd] += c
			tmpFile.close()
		
	def loadPushPopTemplates(self):
		"""load the template file for each push or pop command"""
		self.pushPopTemplates = dict()
		for cmd in self.pushPopTempNames:
			tmpFile = open("templates/pushPop/" + cmd + ".asm")
			self.pushPopTemplates[cmd] = ""
			for c in tmpFile:
				self.pushPopTemplates[cmd] += c
			tmpFile.close()
	
	def loadFlowTemplates(self):
		self.flowTemplates = dict()
		#goto
		tmpFile = open("templates/GOTO.asm")
		self.gotoTemplate = ""
		for c in tmpFile:
			self.gotoTemplate += c
		tmpFile.close()
		tmpFile = open("templates/IF-GOTO.asm")
		self.ifgotoTemplate = ""
		for c in tmpFile:
			self.ifgotoTemplate += c
		tmpFile.close()
	
	def setFileName(self, fName):
		"""Set the name of the current vm file being read from. Used for static variable names"""
		self.curVmFile = path.splitext(fName)[0]
	
	def writeBootStrap(self,):
		"""Write the startup code"""
		
	
	def writeArithmetic(self, cmd):
		"""Write cmd out to the file as assembly. cmd should be a string containing a arithetic vm command"""
		#self.outFile.write("//" + cmd + "\n")
		template = Template(self.arithmeticTemplates[cmd])
		template.num = str(self.labelCounter)
		self.outFile.write(str(template))
		#self.outFile.write("//End " + cmd + "\n")
		self.labelCounter += 1
	
	def writePushPop(self, cmd, segment, index):
		"""Write a push or pop command to the file as assembly. cmd tells whether to push or pop, segment
		tells which segment of memory to operate on, index is a non negative int that tells the offset to use"""
		#self.outFile.write("//" + cmd + " " + segment + " " + str(index) + "\n")
		
		#local, argument, this, that = common
		if self.commonSegments.count(segment) > 0:
			template = Template(self.pushPopTemplates[cmd + "_COMMON"])
			template.index = str(index)
			template.segment = self.segmentTranslation[segment]
		elif segment == "TEMP" or segment == "POINTER" or segment == "STATE":
			template = Template(self.pushPopTemplates[cmd + "_DIRECT"])
			if segment == "TEMP":
				template.index = str(5 + index)
			elif segment == "POINTER":
				template.index = str(3 + index)
			else:
				template.index = str(index)
		elif segment == "STATIC":
			template = Template(self.pushPopTemplates[cmd + "_STATIC"])
			template.varName = self.curVmFile + "." + str(index)
		#constant
		else:# segment == "CONSTANT":
			template = Template(self.pushPopTemplates[cmd + "_CONSTANT"])
			template.const = str(index)
		#print template
		self.outFile.write(str(template))
		#self.outFile.write("//End " + cmd + "\n")
		
	def writeLabel(self, labelName):
		"""write a label"""
		self.outFile.write("(" + self.functName + "$" + labelName + ")\n")
	
	def writeGoto(self, cmd, labelName):
		"""write a goto statement that jumps to labelName"""
			
		if cmd == "GOTO":
			template = Template(self.gotoTemplate)
		else:
			template = Template(self.ifgotoTemplate)
		template.labelName = self.functName + "$" + labelName
		#self.outFile.write("//" + cmd + " " + labelName + "\n")
		self.outFile.write(str(template))
		#self.outFile.write("//End GOTO\n")
	
	def writeFunct(self, fName, numVars):
		"""write a function"""
		self.functName = fName
		#self.outFile.write("//Function " + fName + "\n")
		self.outFile.write("(" + fName + ")\n")
		for i in xrange(numVars):
			self.writePushPop("PUSH", "CONSTANT", 0)
	
	def writeReturn(self):
		"""write the return from function code."""
		
		a=1
		b=2
		c=3
		self.outFile.write("//RETURNING\n")
		#frame = temp 0 = LCL
		self.writePushPop("PUSH", "STATE", "LCL")
		self.writePushPop("POP", "TEMP", a)
		#ret = FRAME-5
		self.writePushPop("PUSH", "TEMP", a)
		self.writePushPop("PUSH", "CONSTANT", 5)
		self.writeArithmetic("SUB")
		self.writePushPop("POP", "TEMP", b)
		#put return value into arg
		self.writePushPop("POP", "ARGUMENT", 0)
		#restore state
		#SP=ARG+1
		self.writePushPop("PUSH", "STATE", "ARG")
		self.writePushPop("PUSH", "CONSTANT", 1)
		self.writeArithmetic("ADD")
		self.writePushPop("POP", "STATE", "SP")
		#THAT
		self.writePushPop("PUSH", "TEMP", a)
		self.writePushPop("PUSH", "CONSTANT", 1)
		self.writeArithmetic("SUB")
		self.writePushPop("POP", "TEMP", c)
		self.outFile.write("""@"""+str(c+5)+"""
D=M
@4
M=D
""")
		
		#THIS
		self.writePushPop("PUSH", "TEMP", a)
		self.writePushPop("PUSH", "CONSTANT", 2)
		self.writeArithmetic("SUB")
		self.writePushPop("POP", "TEMP", c)
		self.outFile.write("""@"""+str(c+5)+"""
D=M
@3
M=D
""")
		
		#ARG
		self.writePushPop("PUSH", "TEMP", a)
		self.writePushPop("PUSH", "CONSTANT", 3)
		self.writeArithmetic("SUB")
		self.writePushPop("POP", "TEMP", c)
		self.outFile.write("""@"""+str(c+5)+"""
D=M
@2
M=D
""")
		
		#LCL
		self.writePushPop("PUSH", "TEMP", a)
		self.writePushPop("PUSH", "CONSTANT", 4)
		self.writeArithmetic("SUB")
		self.writePushPop("POP", "TEMP", c)
		self.outFile.write("""@"""+str(c+5)+"""
D=M
@1
M=D
""")
		
		#goto RET
		self.outFile.write("""@"""+str(b+5)+"""
A=M
0;JMP
""")
		
	
	def writeCall(self, fName, numArgs):
		"""write the code to call fName function. numArgs is the nubmer of arguments pushed"""
		
		retAddr = self.functName + "RetAddr" + str(self.labelCounter)
		self.labelCounter += 1
		
		#self.outFile.write("//Call " + fName + " " + str(numArgs))
		
		#save state
		self.writePushPop("PUSH", "STATE", retAddr)
		self.writePushPop("PUSH", "STATE", "LCL")#yay weak typing
		self.writePushPop("PUSH", "STATE", "ARG")
		self.writePushPop("PUSH", "STATE", "THIS")
		self.writePushPop("PUSH", "STATE", "THAT")
		#set ARG
		self.writePushPop("PUSH", "STATE", "SP")
		self.writePushPop("PUSH", "CONSTANT", numArgs + 5)
		self.writeArithmetic("SUB")
		self.writePushPop("POP", "STATE", "ARG")
		#set LCL to SP
		self.writePushPop("PUSH", "STATE", "SP")
		self.writePushPop("POP", "STATE", "LCL")
		self.writeGoto("GOTO", fName)
		self.outFile.write("(" + retAddr + ")\n")
		
	def close(self):
		"""Close the output file"""
		#self.outFile.write("(WEAREDONE)\n@WEAREDONE\n0;JMP\n")
		self.outFile.close()
