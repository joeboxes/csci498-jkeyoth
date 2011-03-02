
class Parser:
	"""Parses vm code"""
	
	def __init__(self, vmName):
		"""Constructor. Read vmFile into an array of commands."""
		vmFile = open(vmName)
		self.commands = []
		self.curCommand = -1
		for line in vmFile:
			noComment = line.split("//")[0].strip()
			if len(noComment) > 0:
				self.commands.append(noComment)
		vmFile.close()
	
	def hasMoreCommands(self):
		"""Return true if there are more commands to parse"""
		return self.curCommand < len(self.commands) - 1
	
	def advance(self):
		"""Set the current command to the next command, if there are more commands to parse"""
		if self.hasMoreCommands():
			self.curCommand += 1
		else:
			print "End of command list"
	
	def reset(self):
		"""reset current command to -1"""
		self.curCommand = -1
	
	def commandType(self):
		"""Return the type of the current command"""
		pass
	
	def arg1(self):
		"""Return the first arg of the current command. If current command type is arithmetic,
		return the command itself. If teh current command type is return, do not return anything."""
		pass
	
	def arg2(self):
		"""return the second argument of the current command, if there is one, as an int"""
		pass
	