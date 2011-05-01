#!/usr/bin/ruby
require "Verbose.rb"
require "JackTokenizer.rb"
require "rubygems"
require "ruby-debug"
require "ParseNode.rb"
require "tree"
require "VMWriter2"

class CompilationEngine2 < Verbose
	
	
	CLASS_VAR_STARTS = ["static", "field"]
	SUB_STARTS = ["constructor", "function", "method"]
	VAR_TYPES = ["int", "char", "boolean"]
	SUB_TYPES = VAR_TYPES + ["void"]
	STATE_STARTS = ["let", "if", "while", "do", "return"]
	KEYWORD_CONSTANTS = ["true", "false", "null", "this"]
	OPS = ["+", "-", "*", "/", "&", "|", "<", ">", "="]
	UNIARY_OPS = ["-", "~"]
	
	
	
	def initialize(v=false)
		@tokenizer = nil
		super(v)
		@verbose = v
		@nodeNameCounter = -1
		
		@staticTable = SymbolTable.new(v)#class scope
		@fieldTable = SymbolTable.new(v)#class scope
		@argumentTable = SymbolTable.new(v)#method scope
		@varTable = SymbolTable.new(v)#method scope
		@functionTable = SymbolTable.new(v)#class scope
		
	end
	
	def getNextName()
		@nodeNameCounter += 1
		return String(@nodeNameCounter)
	end
	
	def setTokenizer(t)
		@tokenizer = t
	end
	
	def setFileName(fname)
		@writer = VMWriter2.new(fname, @verbose)
	end
	
	def compileClass() # 'class' className '{' classVarDec* subroutineDec* '}'
		@tokenizer.resetIndex # go to first
		#@tokenizer.advance#do class keyword #the hell?
		if checkSameValue(@tokenizer.getCurrItem,"class")
			@rootNode = getNewNode("class")
			@rootNode << getNewNode("keyword", "class")
			
		else
			#error here - first non comment word must be class
			raise "Need class"
			exit
		end
		@tokenizer.advance#do class name
		@rootNode << compileIdentifier(@tokenizer.getCurrItem)
		
		@className = @tokenizer.getCurrItem
		
		@tokenizer.advance#{
		@rootNode << compileSymbol("{")
		
		#compile the class vars
		@tokenizer.advance
		while contains(CLASS_VAR_STARTS, @tokenizer.getCurrItem)
			@rootNode << compileClassVar()
			@tokenizer.advance
		end
		
		#compile the subroutines
		#where the real fun starts!
		while contains(SUB_STARTS, @tokenizer.getCurrItem)
			@rootNode << compileSubroutineDec()
			@tokenizer.advance
		end
		
		
		@tokenizer.advance
		@rootNode << compileSymbol("}")
		
		return @rootNode
	end
	
	#compile higher level things--------------------------------------------
	#these will call the token type compilers, return subtree of many nodes
	#these methods will advance tokenizer
	def compileSubroutineDec()
		
		@argumentTable.clearTable
		@varTable.clearTable
		
		compileKeyword(@tokenizer.getCurrItem)
		subType = @tokenizer.getCurrItem
		
		@tokenizer.advance
		#get return type
		if contains(SUB_TYPES, @tokenizer.getCurrItem)
			compileKeyword(@tokenizer.getCurrItem)
		else
			compileIdentifier(@tokenizer.getCurrItem)
		end
		
		@tokenizer.advance
		#get name of sub
		compileIdentifier(@tokenizer.getCurrItem)
		
		subName = @tokenizer.getCurrItem
		
		@functionTable.addEntry(subName, subType)
		
		#open parenth
		@tokenizer.advance
		compileSymbol("(")
		
		
		@tokenizer.advance
		compileParamList()
		
		#close parenth
		@tokenizer.advance
		compileSymbol(")")
		
		#{
		@tokenizer.advance
		compileSymbol("{")
		
		
		#do subroutine vars
		@tokenizer.advance
		while checkSameValue(@tokenizer.getCurrItem, "var")
			compileSubroutineVars()
			@tokenizer.advance
		end
		
		@writer.writeFunction(@className, subName, @varTable.getLength)
		
		if subType == "constructor"
			@writer.writePush("constant", @curFunctNumVars)
			@writer.writeCall("Memory", "alloc", 1)
			@writer.writePop("pointer", 0)
		elsif subType == "method"
			@writer.writePush("argument", 0)
			@writer.writePop("pointer", 0)
		end
		
		#now the horifying part: statements!
		compileStatements()
		
		
		@tokenizer.advance
		compileSymbol("}")
		
	end
	
	#recursive time! do some statements!
	#warning, this is recursive, but the recursive calls are in the methods this one calls
	#i.e compileStatements calls compileIf, which calls compileStatements, which could call compileIf....
	#if a painting of that painting is normal recursion, this is like two mirrors facing each other
	def compileStatements()
		while contains(STATE_STARTS, @tokenizer.getCurrItem)
			case @tokenizer.getCurrItem
				when "let"
				compileLet()
				when "if"
				compileIf()
				when "while"
				compileWhile()
				when "do"
				compileDo()
				when "return"
				compileReturn()
			end
			@tokenizer.advance
		end
		@tokenizer.retract
	end
	
	#no longer generate xml tree
	def compileExpression()
		arr = genExpTreeArr
		
		rpn = toRPN(arr)
		
		for toke in rpn
			if contains(OPS, toke) || toke == "%" || toke == "~"
				@writer.writeArithmetic(symbolToVM(toke))
			elsif toke.class == Array
				writeSubCall(toke)
			elsif toke == "true"
				@writer.writePush("constant", 1)
				@writer.writeArithmetic("neg")
				
			elsif toke == "false" || toke == "null"
				@writer.writePush("constant", 0)
				
			elsif checkSameType(toke, JackTokenizer.TYPE_IDENTIFIER)
				seg, ind = getSegmentIndex(toke)
				@writer.writePush(seg, ind)
			elsif checkSameType(toke, JackTokenizer.TYPE_INT)
				@writer.writePush("constant", toke)
			end
		end
	end
	
	def writeSubCall(subArr)
		if subArr.length == 2
			@writer.writeCall(nil, subArr[0], subArr[1])
		elsif subArr.length == 3
			@writer.writeCall(subArr[0], subArr[1], subArr[2])
		end
	end
	
	def symbolToVM(sym)
		case sym
			when "-"
			return "sub"
			when "%"
			return "neg"
			when "+"
			return "add"
			when "*"
			return "call Math.multiply 2"
			when "/"
			return "call Math.divide 2"
			when "&"
			return "and"
			when "|"
			return "or"
			when "<"
			return "lt"
			when ">"
			return "gt"
			when "="
			return "eq"
			when "~"
			return "not"
		end
	end
	def toRPN(arr)
		kwayway = []
		stack = []
		for toke in arr
			if toke.class == Array
				if toke[0] == "%SUB%"
					kwayway += callToRPN(toke[1..-1])
				else
					kwayway += toRPN(toke)
				end
				
			elsif contains(OPS, toke) || toke == "%" || toke == "~"
				stack.push toke
				
			elsif checkSameType(toke, JackTokenizer.TYPE_IDENTIFIER) \
				|| checkSameType(toke, JackTokenizer.TYPE_INT)
				kwayway.push toke
			elsif contains(KEYWORD_CONSTANTS, toke)
				kwayway.push toke
			end
			
		end
		
		while stack[-1] != nil
			kwayway.push stack.pop
		end
		
		return kwayway
		
	end
	
	def callToRPN(callArr)
		sub = callArr[0]
		params = callArr[2..-2]
		que = []
		for p in params
			que += toRPN(p)
		end
		
		que.push sub.split(".") + [params.length]
		
		return que	
	end
	
	def genExpTreeArr()
		#r = getNewNode("expression")
		
		r = []
		
		r += compileTerm()
		
		while contains(OPS, @tokenizer.peek)
			@tokenizer.advance
			
			#r <<compileSymbol()
			r += [@tokenizer.getCurrItem]
			@tokenizer.advance
			r += compileTerm()
		end
		
		
		
		return r
	end
	
	def compileTerm()
		#r = getNewNode("term")
		
		toke = @tokenizer.getCurrItem
		if checkSameType(toke, JackTokenizer.TYPE_INT)
			#r << compileConstant("integerConstant", toke)
			return [toke]
			
			
		elsif checkSameType(toke, JackTokenizer.TYPE_STRING)
			#r << compileConstant("stringConstant", toke)
			return [toke[1..-2]]
			#con = toke[1..-2]
			#len = con.length
			#@writer.writePush("constant", len)
			#@writer.writeCall("String", "new", 1)
			#(0..len-1).each do |i|
			#	@writer.writePush("constant", con[i])
			#	@writer.writeCall("String", "new", 2)
			#end
			
			
		elsif contains(KEYWORD_CONSTANTS, toke)
			#r << compileKeyword(toke)
			return [toke]
			#case toke
			#	when "true"
			#		@writer.writePush("constant", 1)
			#		@writer.writeArithmetic("neg")
			#	when "false"
			#		@writer.writePush("constant", 0)
			#	when "null"
			#		@writer.writePush("constant", 0)
			#	else
			#		raise "Keyword constant #{toke} not recognized (should be true, false, null)"
			#		exit
			#end
			
		elsif contains(UNIARY_OPS, toke)
			#r << compileSymbol(toke)
			@tokenizer.advance
			other = compileTerm
			
			if (toke == "-")
				return ["%"] + other #to get rid of the minus or neg confussion
			else
				return [toke] + other
			end
		elsif isSubCall?
			return [["%SUB%"] + compileSubroutineCall()]
			
		elsif checkSameValue(toke, "(")#in parenths
			#TODO: make this work for reals
			#r << compileSymbol("(")
			@tokenizer.advance
			a = [genExpTreeArr()]
			@tokenizer.advance
			#r << compileSymbol(")")
			return a
			
		elsif isArrayThinger?#varName[expression]
			#r << compileIdentifier()
			a = [toke]
			@tokenizer.advance
			#r << compileSymbol("[")
			@tokenizer.advance
			a += genExpTreeArr()
			@tokenizer.advance
			#r << compileSymbol("]")
			return a
			
		else#is a varName
			#r << compileIdentifier()
			return [toke]
		end
		
	end
	
	def isSubCall?
		if checkSameType(@tokenizer.getCurrItem, JackTokenizer.TYPE_IDENTIFIER)
			peeked = @tokenizer.peek
			return (checkSameValue(peeked, ".") or checkSameValue(peeked, "("))
		end
		return false
	end
	
	def isArrayThinger?
		if checkSameType(@tokenizer.getCurrItem, JackTokenizer.TYPE_IDENTIFIER)
			peeked = @tokenizer.peek
			return checkSameValue(peeked, "[")
		end
		return false
	end
	
	def compileExpressionList()
		#r = getNewNode("expressionList")
		
		if not checkSameValue(@tokenizer.getCurrItem, ")")
			#r << compileExpression()
			ret = [genExpTreeArr]
		else#is empty, go back one
			@tokenizer.retract
			return
		end
		@tokenizer.advance
		while not checkSameValue(@tokenizer.getCurrItem, ")")
			compileSymbol(",")
			@tokenizer.advance
			ret += [genExpTreeArr]
			@tokenizer.advance
		end
		
		@tokenizer.retract
		
		return ret
	end
	def compileLet()
		compileKeyword("let")
		
		#var name
		@tokenizer.advance
		compileIdentifier(@tokenizer.getCurrItem)
		
		destName = @tokenizer.getCurrItem
		segment, index = getSegmentIndex(destName)
		arrayThing = false
		
		@tokenizer.advance
		#check if this is an array thing
		if checkSameValue(@tokenizer.getCurrItem, "[")#array thinger
			arrayThing = true
			compileSymbol("[")
			
			@writer.writePush(segment, index)#push array addr
			
			@tokenizer.advance
			compileExpression()
			
			@writer.writeArithmetic("add")#add array addr and result of [expression]
			
			@tokenizer.advance
			compileSymbol("]")
			@tokenizer.advance
		end
		
		compileSymbol("=")
		
		@tokenizer.advance
		
		compileExpression()
		
		if arrayThing
			@writer.writePop("temp", 0)#pop result of right side expression to temp
			@writer.writePop("pointer", 1) #pop array addr (a[3]) to pointer 1, i.e set that = a[3]
			@writer.writePush("temp", 0)#push result of ride side
			@writer.writePop("that", 0)#set the array location to result of right side
		else
			@writer.writePop(segment, index)#right side was pushed in compileExpression
		end
		
		@tokenizer.advance
		compileSymbol(";")
		
	end
	
	def compileIf()
		compileKeyword("if")
		
		@tokenizer.advance
		compileSymbol("(")
		
		@tokenizer.advance
		compileExpression()
		
		@tokenizer.advance
		compileSymbol(")")
		
		lab = getNextName
		
		@writer.writeIf("IF_TRUE"+lab)
		@writer.writeGoto("IF_FALSE"+lab)
		@writer.writeLabel("IF_TRUE"+lab)
		
		@tokenizer.advance
		compileSymbol("{")
		
		@tokenizer.advance
		compileStatements()
		
		@tokenizer.advance
		compileSymbol("}")
		@writer.writeGoto("IF_END"+lab)
		@writer.writeLabel("IF_FALSE"+lab)
		
		#check if this if has an else
		@tokenizer.advance
		if checkSameValue(@tokenizer.getCurrItem, "else")
			compileKeyword("else")
			@tokenizer.advance
			compileSymbol("{")
			@tokenizer.advance
			compileStatements()
			@tokenizer.advance
			compileSymbol("}")
			
		else
			@tokenizer.retract
		end
		
		@writer.writeLabel("IF_END"+lab)
		
	end
	
	def compileWhile()
		compileKeyword("while")
		
		lab = getNextName
		@writer.writeLabel("WHILE"+lab)
		
		@tokenizer.advance
		compileSymbol("(")
		@tokenizer.advance
		compileExpression()
		@tokenizer.advance
		compileSymbol(")")
		
		@writer.writeArithmetic("not")
		@writer.writeIf("WHILE_END"+lab)
		
		@tokenizer.advance
		compileSymbol("{")
		@tokenizer.advance
		compileStatements()
		@tokenizer.advance
		compileSymbol("}")
		
		@writer.writeGoto("WHILE"+lab)
		@writer.writeLabel("WHILE_END"+lab)
		
	end
	
	def compileDo()
		compileKeyword("do")
		@tokenizer.advance
		compileExpression()
		@tokenizer.advance
		compileSymbol(";")
		@writer.writePop("temp", 0)
	end
	
	def compileReturn()
		compileKeyword("return")
		
		@tokenizer.advance
		if checkSameValue(@tokenizer.getCurrItem, ";")#no return value
			compileSymbol(";")
			@writer.writePush("constant", 0)
			
		else
			compileExpression()
			@tokenizer.advance
			compileSymbol(";")
		end
		@writer.writeReturn
		
	end
	
	#why doesnt this have a surrounding tag? grrr
	def compileSubroutineCall()
		#r << compileIdentifier(@tokenizer.getCurrItem)
		maybeClassMaybeSub = @tokenizer.getCurrItem
		subName = nil
		@tokenizer.advance
		if checkSameValue(@tokenizer.getCurrItem, ".")
			#r << compileSymbol(".")
			@tokenizer.advance
			#r << compileIdentifier(@tokenizer.getCurrItem)
			subName = @tokenizer.getCurrItem
			@tokenizer.advance
		end
		if subName == nil
			ret = [maybeClassMaybeSub, "("]
		else
			ret = [maybeClassMaybeSub + "." + subName, "("]
		end
		#r << compileSymbol("(")
		
		@tokenizer.advance
		expListR = compileExpressionList()
		if expListR != nil
			ret += expListR
		end
		@tokenizer.advance
		ret += [")"]
		#r << compileSymbol(")")
		return ret
	end
	
	def compileSubroutineVars()
		r = getNewNode("varDec")
		r << compileKeyword("var")
		
		@tokenizer.advance
		
		#type
		if contains(VAR_TYPES, @tokenizer.getCurrItem)
			r << compileKeyword(@tokenizer.getCurrItem)
		else
			r << compileIdentifier(@tokenizer.getCurrItem)
		end
		
		type = @tokenizer.getCurrItem
		
		@tokenizer.advance
		hitOne = false
		while checkSameType(@tokenizer.getCurrItem, JackTokenizer.TYPE_IDENTIFIER)
			hitOne = true
			r << compileIdentifier(@tokenizer.getCurrItem)
			
			@varTable.addEntry(@tokenizer.getCurrItem, type)
			
			@tokenizer.advance
			
			if checkSameValue(@tokenizer.getCurrItem, ",") or checkSameValue(@tokenizer.getCurrItem, ";")
				r << compileSymbol(@tokenizer.getCurrItem)
			else
				#error here - not a ; or ,
				raise "No comma or semicolon found in subroutine vars"
				exit
			end
			@tokenizer.advance
		end
		
		if hitOne
			@tokenizer.retract
			return r
		end
		
		#error here - found something like "var int" but no identifier
		raise "No identifier found in subroutine vars"
		exit
	end
	
	def compileParamList()
		r = getNewNode("parameterList")
		
		#do multiple parameters
		while (contains(VAR_TYPES, @tokenizer.getCurrItem) or checkSameType(@tokenizer.getCurrItem, JackTokenizer.TYPE_IDENTIFIER)) 
			#do type
			if contains(VAR_TYPES, @tokenizer.getCurrItem)
				r << compileKeyword(@tokenizer.getCurrItem)
			else
				r << compileIdentifier(@tokenizer.getCurrItem)
			end
			type = @tokenizer.getCurrItem
			
			#do name of parameter
			@tokenizer.advance
			r << compileIdentifier(@tokenizer.getCurrItem)
			
			@argumentTable.addEntry(@tokenizer.getCurrItem, type)
			
			@tokenizer.advance
			if checkSameValue(@tokenizer.getCurrItem, ")")
				break
			end
			r << compileSymbol(",")
			
			@tokenizer.advance
		end
		@tokenizer.retract
		return r
	end
	def compileClassVar()
		r = getNewNode("classVarDec")
		r << compileKeyword(@tokenizer.getCurrItem)
		
		varType = @tokenizer.getCurrItem
		
		@tokenizer.advance
		if contains(VAR_TYPES, @tokenizer.getCurrItem)
			r << compileKeyword(@tokenizer.getCurrItem)
		else
			r << compileIdentifier(@tokenizer.getCurrItem)
		end
		
		type = @tokenizer.getCurrItem
		
		hitOne = false#make sure there is at least one identifier
		@tokenizer.advance
		while checkSameType(@tokenizer.getCurrItem, JackTokenizer.TYPE_IDENTIFIER)
			hitOne = true
			r << compileIdentifier(@tokenizer.getCurrItem)
			
			if(varType == "field")
				@fieldTable.addEntry(@tokenizer.getCurrItem, type)
			else
				@staticTable.addEntry(@tokenizer.getCurrItem, type)
			end
			@tokenizer.advance
			
			if checkSameValue(@tokenizer.getCurrItem, ",") or checkSameValue(@tokenizer.getCurrItem, ";")
				r << compileSymbol(@tokenizer.getCurrItem)
			else
				#error here - not a ; or ,
				raise "No comma or semicolon found in class vars"
				exit
			end
			@tokenizer.advance
		end
		
		if hitOne
			@tokenizer.retract
			return r
		end     
		
		#error here - something alone the lines of "field int" found, but no identifiers found
		raise "No identifier found in class vars"
		exit
		
	end
	
	
	
	#Compile a token type---------------------------------------------------
	#All of these return a subtree (usually 2 nodes, xml tag and value to go in that tag)
	#these methods will not advance tokenizer
	
	def compileSymbol(symbol=nil)
		if checkSameValue(@tokenizer.getCurrItem, symbol)
			symNode = getNewNode("symbol", symbol)
		elsif symbol == nil
			symNode = getNewNode("symbol", @tokenizer.getCurrItem)
		else
			#error here - symbol not what was expected
			raise "Wrong symbol found, looking for: #{symbol} but found: #{@tokenizer.getCurrItem}"
			exit
		end
		return symNode
	end
	
	def compileIdentifier(ident=nil)
		if ident == nil
			ident = @tokenizer.getCurrItem
		end
		if checkSameType(@tokenizer.getCurrItem, JackTokenizer.TYPE_IDENTIFIER)
			idNode = getNewNode("identifier", ident)
		else
			#error here - expected an identifier
			raise "Expected an identifier: #{ident}"
		end
		return idNode
		
	end
	
	def compileKeyword(key)
		keyNode = getNewNode("keyword", key)
		return keyNode
	end
	
	def compileConstant(type, const)
		conNode = getNewNode(type, const)
		return conNode
	end
	
	
	#Check value or type-----------------------------------------------
	#return booleans, should add messages to these for when str != expected
	#these will not advance tokenizer
	def checkSameValue(str, expected)
		
		#return (str != nil and expected != nil and 
		#	checkSameType(str,@tokenizer.getType(expected)) and str == expected)
		return str == expected
		
	end
	
	def checkSameType(str, expected)
		return @tokenizer.getType(str) == expected 
		
	end
	
	#return true iff array contains val
	def contains(array, val)
		return array.count(val) > 0
	end
	
	
	#helper function to get a new tree node typing all that out over and over sucks
	def getNewNode(name, parseVal = nil)
		#		printV("creating node: #{name}\t#{(name=="identifier" or name=="integerConstant") ? "" : "\t"}#{parseVal}")
		return Tree::TreeNode.new(name + getNextName, ParseNode.new(name, parseVal))
	end
	
	
	
	def getSegmentIndex(k)
		if @staticTable.has_key?(k)
			return ["static", @staticTable.getIndex(k)]
		elsif @fieldTable.has_key?(k)
			return ["this", @fieldTable.getIndex(k)]
		elsif @argumentTable.has_key?(k)
			return ["argument", @argumentTable.getIndex(k)]
		elsif @varTable.has_key?(k)
			return ["local", @varTable.getIndex(k)]
		end
		raise "Identifier $#{k} not found"
		exit
	end
	
	def printAllTables()
		setVerbose(true)
		puts "Static table:"
		@staticTable.printTable
		puts "\nField table:"
		@fieldTable.printTable
		puts "\nArguments table:"
		@argumentTable.printTable
		puts "\nVar table:"
		@varTable.printTable
		puts "\nFunction table:"
		@functionTable.printTable
		
		setVerbose(@verb)
	end
	
	def setVerbose(v)
		@verbose=v
		@staticTable.setVerbose(v)
		@fieldTable.setVerbose(v)
		@argumentTable.setVerbose(v)
		@varTable.setVerbose(v)
		@functionTable.setVerbose(v)
	end
	
	def close()
		@writer.close
	end
end
