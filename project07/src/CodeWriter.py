from Cheetah.Template import Template


class CodeWriter:
	"""Write code"""
	
	arithmeticTempNames = ["ADD", "SUB", "NEG", "EQ", "GT", "LT", "AND", "OR", "NOT"]
	
	pushPopTempNames = ["POP_COMMON", "POP_CONSTANT", "POP_STATIC", "PUSH_COMMON", \
					"PUSH_CONSTANT", "PUSH_STATIC"]
	
	def __init__(self, outName):
		self.outFile = open(outName, "w")
		pass
	
	def loadArithTemplates(self):
		"""load the template file for each arithmetic command"""
		self.arithmeticTemplates = dict()
		for cmd in self.arithmeticTempNames:
			tmpFile = open("templates/arithmetic/" + cmd + ".asm")
			self.arithmeticTemplates[cmd] = ""
			for c in tmpFile:
				self.arithmeticTemplates[cmd] += c
		
	def loadPushPopTemplates(self):
		"""load the template file for each push or pop command"""
		self.pushPopTemplates = dict()
		for cmd in self.pushPopTempNames:
			tmpFile = open("templates/pushPop/" + cmd + ".asm")
			self.pushPopTemplates[cmd] = ""
			for c in tmpFile:
				self.pushPopTemplates[cmd] += c
	
	def setFileName(self, fName):
		"""Set the name of the current vm file being read from. Used for static variable names"""
		self.curVmFile = fName
		
	
	def writeArithmetic(self, cmd):
		"""Write cmd out to the file as assembly. cmd should be a string containing a arithetic vm command"""
		self.outFile.write("//" + cmd + "\n")
		self.outFile.write(self.arithmeticTemplates[cmd])
		self.outFile.write("//End " + cmd + "\n")
		pass
	
	def writePushPop(self, cmd, segment, index):
		"""Write a push or pop command to the file as assembly. cmd tells whether to push or pop, segment
		tells which segment of memory to operate on, index is a non negative int that tells the offset to use"""
		self.outFile.write("//" + cmd + " " + segment + " " + index)
		
		
	
	def close(self):
		"""Close the output file"""
		self.outFile.close()
