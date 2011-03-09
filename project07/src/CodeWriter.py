
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
		
		self.labelCounter = 0
	
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
		self.curVmFile = path.splitext(fName)[0]
		
	
	def writeArithmetic(self, cmd):
		"""Write cmd out to the file as assembly. cmd should be a string containing a arithetic vm command"""
		self.outFile.write("//" + cmd + "\n")
		template = Template(self.arithmeticTemplates[cmd])
		template.num = str(self.labelCounter)
		self.outFile.write(str(template))
		self.outFile.write("//End " + cmd + "\n")
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
		elif segment == "TEMP" or segment == "POINTER":
			template = Template(self.pushPopTemplates[cmd + "_DIRECT"])
			if segment == "TEMP":
				template.index = str(5 + index)
			else:
				template.index = str(3 + index)
		#constant
		else:# segment == "CONSTANT":
			template = Template(self.pushPopTemplates[cmd + "_CONSTANT"])
			template.const = str(index)
		
		
		
		#print template
		self.outFile.write(str(template))
		#self.outFile.write("//End " + cmd + "\n")
		
	
	def close(self):
		"""Close the output file"""
		self.outFile.write("(WEAREDONE)\n@WEAREDONE\n0;JMP\n")
		self.outFile.close()
