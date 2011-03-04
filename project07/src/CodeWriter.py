
class CodeWriter:
	"""Write code"""
	
	arithmetic_temps = ["ADD","SUB","NEG","EQ","GT","LT","AND","OR","NOT"]
	
	def __init__(self, outName):
		self.outFile = open(outName, "w")
		pass
	
	def loadAsmTemplates(self):
		"""load the template file for each arithmetic command"""
		self.templates = dict()
		for cmd in self.arithmetic_temps:
			tmpFile = open("templates/" + cmd + ".asm")
			self.templates[cmd] = ""
			for c in tmpFile:
				self.templates[cmd] += c
		
		
	
	def setFileName(self, fName):
		"""Have no idea what this would do"""
		pass
	
	def writeArithmetic(self, cmd):
		"""Write cmd out to the file as assembly. cmd should be a string containing a arithetic vm command"""
		self.outFile.write("//" + cmd + "\n")
		self.outFile.write(self.templates[cmd])
		self.outFile.write("\n")
		pass
	
	def writePushPop(self, cmd, segment, index):
		"""Write a push or pop command to the file as assembly. cmd tells whether to push or pop, segment
		tells which segment of memory to operate on, index is a non negative int"""
		pass
	
	def close(self):
		"""Close the output file"""
		self.outFile.close()