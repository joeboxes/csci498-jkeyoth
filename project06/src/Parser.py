
A_COMMAND = "A"
C_COMMAND = "C"
L_COMMAND = "L"
class Parser:
	"""Class to parse the assembly code."""
	
	def __init__(self, asmName):
		"""Constructor. Opens the input assembly file and reads it into an array of commands"""
		asmFile = open(asmName)
		self.commands = []
		self.curCommand = -1
		for line in asmFile:
			noComment = line.split("//")[0].strip()
			if len(noComment) > 0:
				self.commands.append(noComment)
		asmFile.close()
			
	
	def hasMoreCommands(self):
		"""Check if there are more commands to parse"""
		return self.curCommand < len(self.commands) - 1
	
	def advance(self):
		"""Set the current command to the next command, if there is a next command"""
		if self.hasMoreCommands():
			self.curCommand += 1
			return 0
		else:
			return 1
	
	def commandType(self):
		"""Returns the type of the current command. One of A_COMMAND, C_COMMAND, L_COMMAND."""
		firstChar = self.commands[self.curCommand][0]
		if firstChar == "@":
			return A_COMMAND
		if firstChar == "(":
			return L_COMMAND
		possCComStarts = ["A", "D", "M", "-", "0", "1", "!"]
		if possCComStarts.count(firstChar) > 0:
			return C_COMMAND
		
		print "Bad assembly command :", self.commands[self.curCommand]
		exit(1)
	
	def symbol(self):
		"""Returns the value or variable after the @ in an A command. One of: constant
		value such as 13252, variable such as sum, or symbol such as LOOP for (LOOP). """
		
		#if current command is a C command, return None. Should not ever happen.
		if self.commandType() == C_COMMAND:
			return None;
		
		#return everything after the @
		if self.commandType() == A_COMMAND:
			return self.commands[self.curCommand][1:]
		
		#return everything inside of the ()
		cmd = self.commands[self.curCommand]
		return cmd[cmd.index("(")+1:cmd.index(")")]
	
	def dest(self):
		"""Returns the string representation of the dest portion of the C command, such as D or AD"""
		cmd = self.commands[self.curCommand]
		if cmd.count("="):
			return cmd[:cmd.index("=")]
		return None
	
	def comp(self):
		"""Returns the string representation of the comp portion of the C command, such as D+1 or D&M"""
		cmd = self.commands[self.curCommand]
		if cmd.count(";") > 0:
			if cmd.count("=") > 0:
				return cmd[cmd.index("=")+1:cmd.index(";")]
			return cmd[:cmd.index(";")]
		
		if cmd.count("=") > 0:
			return cmd[cmd.index("=")+1:]
		return cmd
	
	def jump(self):
		"""Returns the string representation of the jump portion of the C command, such as JGE or JLT"""
		cmd = self.commands[self.curCommand]
		if cmd.count(";") > 0:
			return cmd[cmd.index(";")+1:]
		return None
	
	def reset(self):
		self.curCommand = -1
		
	def printInst(self):
		for c in self.commands:
			print c
		