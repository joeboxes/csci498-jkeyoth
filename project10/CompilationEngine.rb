#!/usr/bin/ruby
#CompilationEngine.rb Verbose
require "Verbose.rb"
require "JackTokenizer.rb"

class CompilationEngine < Verbose
	def initialize(v=false)
		@tokenizer = nil
		super(v)
	end
	def setTokenizer(t)
		@tokenizer = t
	end
	
	def checkExpectedType(type, expected) # returns actual object, if exists
		if type == expected
			return @tokenizer.getCurrItem()
		end
		printCompileError(str)#puts "unexpected type: #{type} != expected type: #{expected}"
		return nil
	end
	
	def checkSameType(str)
		expected = @tokenizer.getType(str);
		return checkExpectedType( @tokenizer.tokenType, expected )
	end
	def checkSameTypeBoolean(type)
		if @tokenizer.tokenType == type
			return true
		end
		return false
	end
	
	def checkSameValue(str)
		obj = checkSameType(str)
		if obj!= nil && obj == str
			return true
		end
		#printCompileError(str)
		return false
	end
	
	def printCompileError(expected)
		unexp = @tokenizer.getItem(@tokenizer.tokenType)
		puts "expected '#{expected}', given '#{unexp}'\n"
	end

# COMPILE FORMAT: coming in: point to first string needed by function
#				coming out: point to last string needed by function + 1

	
	def compileClass() # 'class' className '{' classVarDec* subroutineDec* '}'
printV("compile class\n")
		@tokenizer.resetIndex # go to first
		if checkSameValue("class")
			@tokenizer.advance
			if compileClassName()
				if checkSameValue("{")
					@tokenizer.advance
					if compileClassVarDec() && compileSubroutineDec() # change these to LISTs
						if checkSameValue("}")
							@tokenizer.advance
							return true
						end
					end
				end
			end
		end
printV("AT: '#{@tokenizer.getCurrItem()}'\n")
		return false
	end
	def compileVarDecEnd() # type varName (',' varName)* ';'
printV("compileVarDecEnd\n")
		if compileType()
			if compileVarName()
				ret = checkSameValue(",")
				while ret
					@tokenizer.advance
					ret = compileVarName()
					if ret 
						ret = checkSameValue(",")
					else
						return false
					end
				end
				if checkSameValue(";")
					@tokenizer.advance
					return true
				end
			end
		end
		return false
	end
	def compileClassVarDec() # ('static' | 'field') type varName (',' varName)* ';'
printV("compileClassVarDec\n")
		if checkSameValue("static") || checkSameValue("field")
			@tokenizer.advance
			return compileVarDecEnd()
		end
		return true
	end
	def compileVarDec() # 'var' type varName (',' varName)* ';'
printV("compileVarDec\n")
		if checkSameValue("var")
			@tokenizer.advance
			return compileVarDecEnd()
		end
		return false
	end
	def compileSubroutineDec() # subroutine*
printV("compileSubroutineDec\n")
		ret = true
		while ret
			ret = compileSubroutine()
		end
		return false
	end
	def compileSubroutine() # ('constructor' | 'function' | 'method') ('void' | type) subName '(' parameterList ')' subroutineBody
printV("compileSubRoutine\n")
		if checkSameValue("constructor") || checkSameValue("function") || checkSameValue("method")
			@tokenizer.advance
			if checkSameValue("void")
				@tokenizer.advance
			elsif compileType
				#
			else
				return false
			end
			if compileSubroutineName()
				if checkSameValue("(")
					@tokenizer.advance
					if compileParameterList()
						if checkSameValue(")")
							return compileSubroutineBody()
						end
					end
				end
			end
		end
		#
		return false
	end
	def compileParameterList()
printV("compileParameterList\n")
		return false
	end
	def compileSubroutineBody() # '{' varDec* statements '}'
printV("compileSubroutineBody\n")
		if checkSameValue("{")
			ret = compileVarDec(adv) # varDecs
			while ret
				ret = compileVarDec(ret)
			end
			ret = compileStatements() # statements
			while ret
				ret = compileStatements(ret)
			end
			if checkSameValue("}")
				return true;
			end
		end
		return false
	end
	def compileStatements() # statement*
printV("compileStatements\n")
		ret = true
		while ret
			ret = compileStatement()
		end
		return false
	end
	def compileStatement() # letStatement | ifStatement | whileStatement | doStatement | returnStatement
printV("compileStatement\n")
		if checkSameValue("let")
			compileLet(false)
		elsif checkSameValue("do")
			compileDo(false)
		elsif checkSameValue("return")
			compileReturn(false)
		end
		return false
	end
	def compileDo()
printV("compileDo\n")
		return false
	end
	def compileLet() # 'let' varName ('[' expression ']') '=' expression ';'
printV("compileLet\n")
		if checkSameValue("let")
			@tokenizer.advance
			if checkSameType("varName")
				@tokenizer.advance
				if checkSameValue("[")
					ret = compileExpression(true)
					if ret 
						if checkSameValue("]")
							@tokenizer.advance
						else
							return false;
						end
					else
						return false;
					end
				end
				if checkSameValue("=")
					ret = compileExpression(true)
					if true
						@tokenizer.advance
						if checkSameValue(";")
printV("let successful\n")
							return true
						end	
					end
				end
			end
		end
		return false
	end
	def compileWhile()
		#
		return false
	end
	def compileReturn()
printV("compileReturn\n")
		#
		return false
	end
	def compileIf()
		#
		return false
	end
	def compileExpression() # term (op term)*
printV("compileExpression\n")
		if compileTerm()
			@tokenizer.advance
			while compileOp()
				compileTerm()
			end
			@tokenizer.retract
			return true
		end
		return false
	end
	def compileExpressionList(adv)
		#
	end
	def compileTerm() # integerConstant | stringConstant | keywordConst | varName ('[' expression ']')?
					# | subroutineCall | ('(' expression ')') | unaryOp term
printV("compileTerm\n")
		if compileIntConstant()
			return true
		elsif compileStringConstant()
			return true
		elsif compilekeyWordConstant()
			return true
		elsif checkSameType("varName")
			@tokenizer.advance
			if checkSameValue("[")
				if compileExpression()
					if checkSameValue("]")
						@tokenizer.advance
						return true
					end
				else
					return false
				end
			end
			return true
		elsif compileSubroutineCall()
			return true
		end
		return false
	end
	def compileSubroutineCall() # subroutineName '(' expressionList ')' | (className | varName) '.' subroutineName '(' expressionList ')'
		
		return false
	end
	def compileOp() # '+' | '-' | '*' | '/' | '&' | '|' | '<' | '>' | '='
		arr = ["+","-","*","/","&","|","<",">","="]
		if inList(arr)
			@tokenizer.advance
			return true
		end
		return false
	end
	def compileUnaryOp() # '-' | '~'
		arr = ["-","~"]
		if inList(arr)
			@tokenizer.advance
			return true
		end
		return false
	end
	def compilekeyWordConstant() # 'true' | 'false' | 'null' | 'this' 
		arr = ["true","false","null","this"]
		if inList(arr)
			@tokenizer.advance
			return true
		end
		return false
	end
	def compileStringConstant() # anything in quotes
		return checkSameTypeBoolean(JackTokenizer.TYPE_STRING)
	end
	def compileIntConstant() # anything int
		return checkSameTypeBoolean(JackTokenizer.TYPE_INT)
	end
	def compileClassName() # identifier
		return compileIdentifier()
	end
	def compileSubroutineName() # identifier
		return compileIdentifier()
	end
	def compilevarName() # identifier
		return compileIdentifier()
	end
	def compileIdentifier() # -
		if checkSameType("id")
			@tokenizer.advance
			return true
		end
		return false
	end
	def compileType() # 'int' | 'char' | 'boolean' | className
		arr = ["int","char","boolean"]
		if inList(arr)
			@tokenizer.advance
			return true
		elsif compileClassName()
			return true
		end
		return false
	end
	def inList(arr)
		arr.each do |op|
			if checkSameValue(op)
				return true
			end
		end
		return false
	end
	
end

if __FILE__ == $0 # this file was called for main
	puts "EXAMPLE USAGE:"
	a = CompilationEngine.new()
	
	# do shit
	
	
	
	
	
	
end
