

class Parser:
	"""Class to parse the assembly code."""
	
	A_COMMAND = 1
	C_COMMAND = 2
	L_COMMAND = 3
	
	
	
	def __init__(self, asmName):
		"""Constructor. Opens the input assembly file and reads it into an array of commands"""
		asmFile = open(asmName)
		self.commands = []
		self.curCommand = 0
		for line in asmFile:
			self.commands.append(line)
			
	
	def hasMoreCommands(self):
		"""Check if there are more commands to parse"""
		return self.curCommand < len(self.commands) - 1
			
	
	def advance(self):
		"""Set the current command to the next command, if there is a next command"""
		self.curCommand += 1
	
	def commandType(self):
		"""Returns the type of the current command. One of A_COMMAND, C_COMMAND, L_COMMAND."""
		firstChar = self.commands[self.curCommand][0]
		if firstChar == "@":
			return Parser.A_COMMAND
		if firstChar == "(":
			return Parser.L_COMMAND
		possCComStarts = ["A", "D", "M", "-", "0", "1", "!"]
		if possCComStarts.count(firstChar) > 0:
			return Parser.C_COMMAND
		
		print "Bad assembly command :", self.commands[self.curCommand]
		exit(1)
	
	def symbol(self):
		"""Returns the value or variable after the @ in an A command. One of: constant
		value such as 13252, variable such as sum, or symbol such as LOOP for (LOOP). """
		if self.commandType() == Parser.C_COMMAND:
			return None;
		
		#return everything after the @
		if self.commandType() == Parser.A_COMMAND:
			return self.commands[self.curCommand][1:]
		
		#return everything inside of the ()
		return self.commands[self.curCommand][1:-1]
	
	def dest(self):
		"""Returns the string representation of the dest portion of the C command, such as D or AD"""
		pass
	
	def comp(self):
		"""Returns the string representation of the comp portion of the C command, such as D+1 or D&M"""
		pass
	
	def jump(self):
		"""Returns the string representation of the jump portion of teh C command, such as JGE or JLT"""
		pass
	

		
	