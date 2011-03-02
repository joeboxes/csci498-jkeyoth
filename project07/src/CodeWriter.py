
class CodeWriter:
	"""Write code"""
	
	def __init__(self, outName):
		"""Constructor. Opens the output file"""
		pass
	
	def setFileName(self, fName):
		"""Have no idea what this would do, since we open the file in the constructor"""
		pass
	
	def writeArithmetic(self, cmd):
		"""Write cmd out to the file as assembly. cmd should be a string containing a arithetic vm command"""
		pass
	
	def writePushPop(self, cmd, segment, index):
		"""Write a push or pop command to the file as assembly. cmd tells whether to push or pop, segment
		tells which segment of memory to operate on, index is a non negative int"""
		pass
	
	def close(self):
		"""Close the output file"""
		pass