
class Parser:
	"""Parses vm code"""
	
	arithmetic_vals = ["ADD","SUB","NEG","EQ","GT","LT","AND","OR","NOT"]
	
	def __init__(self, vmName):
		"""Constructor. Read vmFile into an array of commands."""
		vmFile = open(vmName)
		self.commands = []
		self.curCommand = -1
		for line in vmFile:
			noComment = line.split("//")[0].strip().upper()
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
		cmd = self.com()
		#test for C_ARITHMETIC
		if self.arithmetic_vals.count(cmd) > 0:
			return "C_ARITHMETIC"
		
		c = cmd.split()[0]
		return "C_" + c
	
	def arg1(self):
		"""Return the first arg of the current command. If current command type is arithmetic,
		return the command itself. If the current command type is return, do not return anything."""
		cmd = self.com()
		if self.commandType() == "C_ARITHMETIC":
			return cmd
		if self.commandType() == "C_RETURN":
			return None
		
		return cmd.split()[1]
	
	def arg2(self):
		"""return the second argument of the current command, if there is one, as an int"""
		cmd = self.com()
		type = self.commandType()
		if type == "C_PUSH" or type == "C_POP" or type == "C_FUNCTION" or type == "C_CALL":
			return int(cmd.split()[2])
		return None
	
	def com(self):
		return self.commands[self.curCommand]
	