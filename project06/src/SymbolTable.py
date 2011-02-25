

class SymbolTable:
	"""Hold the table of assembly symbols"""
	
	def __init__(self):
		"""Constructor. Set up the table"""
		self.table = dict()
	
	def addEntry(self, symbolString, address):
		"""Adds the symbol into the table"""
		self.table[symbolString] = address
	
	def contains(self, symbolString):
		"""Returns whether the table contains an entry at symbolString"""
		return self.table.has_key(symbolString)
	
	def getAddress(self, symbolString):
		"""Return the address stored at symbolString"""
		return self.table[symbolString] 