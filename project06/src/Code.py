

def dest(destString):
	"""Return the binary representation of this dest assembly fragment"""
	if destString == None:
		return "000"
	binStr = ""
	for c in "ADM":
		if destString.count(c) > 0:
			binStr += "1"
		else:
			binStr += "0"
	return binStr			

def comp(compString):
	"""Return the binary representation of this comp assembly fragment"""
	binStr = ""
	aORm = ""
	if compString.count("M") > 0:
		binStr += "1"
		aORm = "M"
	else:
		binStr += "0"
		aORm = "A"
	
	
	
	#Oh god the hard coding. Makes me want to take a switch to python
	if compString == "0":
		binStr += "101010"
	elif compString == "1":
		binStr += "111111"
	elif compString == "-1":
		binStr += "111010"
	elif compString == "D":
		binStr += "001100"
	elif compString == aORm:
		binStr += "110000"
	elif compString == "!D":
		binStr += "001101"
	elif compString == "!"+aORm:
		binStr += "110001"
	elif compString == "-D":
		binStr += "001111"
	elif compString == "-"+aORm:
		binStr += "110011"
	elif compString == "D+1":
		binStr += "011111"
	elif compString == aORm + "+1":
		binStr += "110111"
	elif compString == "D-1":
		binStr += "001110"
	elif compString == aORm +"-1":
		binStr += "110010"
	elif compString == "D+" + aORm:
		binStr += "000010"
	elif compString == "D-" + aORm:
		binStr += "010011"
	elif compString == aORm + "-D":
		binStr += "000111"
	elif compString == "D&" + aORm:
		binStr += "000000"
	elif compString == "D|" + aORm:
		binStr += "010101"
	
	return binStr

def jump(jmpString):
	"""Return the binary representation of this jump assembly fragment"""
	
	if jmpString == None:
		return "000"
	
	if jmpString == "JGT":
		return "001"
	if jmpString == "JEQ":
		return "010"
	if jmpString == "JGE":
		return "011"
	if jmpString == "JLT":
		return "100"
	if jmpString == "JNE":
		return "101"
	if jmpString == "JLE":
		return "110"
	if jmpString == "JMP":
		return "111"

def decimalConstantToBinaryString(decimalString):
	"""Return the binary version of decimalString as a string"""
	binVersion = bin(int(decimalString))[2:]
	while len(binVersion) < 15:
		binVersion = "0" + binVersion
	return binVersion