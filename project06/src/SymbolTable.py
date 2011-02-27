

class SymbolTable:
	"""Hold the table of assembly symbols"""
	
	def __init__(self):
		"""Constructor. Set up the table"""
		self.table = dict()
		self.curVarSpot = 16
		self.addEntry("SCREEN", 16384)
		self.addEntry("KBD", 24576)
		#R0-R15
		for i in xrange(16):
			self.addEntry("R" + str(i), i)
		#SP,LCL,ARG,THIS,THAT
		self.addEntry("SP", 0)
		self.addEntry("LCL", 1)
		self.addEntry("ARG", 2)
		self.addEntry("THIS", 3)
		self.addEntry("THAT", 4)
		
	
	def addEntry(self, symbolString, address):
		"""Adds the symbol into the table. Use this to add a label, and addVariable to add a variable"""
		self.table[symbolString] = address
	
	def addVariable(self, varString):
		"""Add a variable to the next spot in memory."""
		self.addEntry(varString, self.curVarSpot)
		self.curVarSpot += 1
	
	def contains(self, symbolString):
		"""Returns whether the table contains an entry at symbolString"""
		return self.table.has_key(symbolString)
	
	def getAddress(self, symbolString):
		"""Return the address stored at symbolString"""
		decimalVersion = self.table[symbolString]
		binVersion = bin(decimalVersion)[2:]
		while len(binVersion) < 15:
			binVersion = "0" + binVersion
		return binVersion