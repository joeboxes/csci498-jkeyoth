from SymbolTable import SymbolTable

tab = SymbolTable()

tab.addEntry("testSymbol", 32767)

print "=====Testing SymbolTable"

if not tab.contains("testSymbol"):
	print "SymbolTable.contains should return true"

if tab.getAddress("testSymbol") != "111111111111111":
	print "SymbolTable.getAddress did not return correct value"
	
tab.addVariable("testVar")

if tab.getAddress("testVar") != "000000000010000":
	print "SymbolTable.getAddress did not return correct value for var"
	
print "Done testing SymbolTable====="