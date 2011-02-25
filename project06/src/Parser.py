

class Parser:
	"""Class to parse the assembly code."""
	
	A_COMMAND = 1
	B_COMMAND = 2
	L_COMMAND = 3
	
	def __init__(self, asmName):
		"""Constructor. Opens the input assembly file"""
		asmFile = open(asmName)
			
	
	def hasMoreCommands(self):
		"""Check if there are more commands to parse"""
		pass
	
	def advance(self):
		"""Set the current command to the next command, if there is a next command"""
		pass
	
	def commandType(self):
		"""Returns the type of the current command. One of A_COMMAND, B_COMMAND, L_COMMAND."""
		pass
	
	def symbol(self):
		"""Returns the value or variable after the @ in an A command. One of: constant
		value such as 13252, variable such as sum, or symbol such as (LOOP). """
		pass
	
	def dest(self):
		"""Returns the string representation of the dest portion of the C command, such as D or AD"""
		pass
	
	def comp(self):
		"""Returns the string representation of the comp portion of the C command, such as D+1 or D&M"""
		pass
	
	def jump(self):
		"""Returns the string representation of the jump portion of teh C command, such as JGE or JLT"""
		pass
	

		
	