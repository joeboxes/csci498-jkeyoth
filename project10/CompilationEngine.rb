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
	
	def checkSameValue(str)
		obj = checkSameType(str)
		if obj!= nil && obj == str
			return true
		end
		printCompileError(str)
		return false
	end
	
	def printCompileError(expected)
		unexp = @tokenizer.getItem(@tokenizer.tokenType)
		puts "expected '#{expected}', given '#{unexp}'\n"
	end
	
	def compileClass() # 'class' className '{' classVarDec* subroutineDec* '}'
		printV("compile class\n")
		@tokenizer.resetIndex
		@tokenizer.advance
		if checkSameValue("class")
			@tokenizer.advance
			if checkSameType("id")
				@tokenizer.advance
				if checkSameValue("{")
					printV("good thus far\n")
					ret = compileClassVarDec(true)
					ret = compileSubroutineDec(ret)
					if ret
						@tokenizer.advance
					end
					if checkSameValue("}")
						return true
					end
				end
			end
		end
		return false
	end
	def compileClassVarDec(adv) # ('static' | 'field') type varName (',' varName)* ';'
		if adv 
			@tokenizer.advance
		end
		if checkSameValue("static") | checkSameValue("field")
			return true
		end
		return false
	end
	def compileSubroutineDec(adv) # subroutine*
		ret = compileSubroutine(adv)
		while ret
			ret = compileSubroutine(ret)
		end
		return false
	end
	def compileSubroutine(adv) # ('constructor' | 'function' | 'method') ('void' | type) subName '(' parameterList ')' subroutineBody
		if adv 
			@tokenizer.advance
		end
		if checkSameValue("constructor") || checkSameValue("function") || checkSameValue("method")
			@tokenizer.advance
			if checkSameValue("void") || checkSameType("type")
				@tokenizer.advance
				if checkSameType("subName")
					@tokenizer.advance
					if checkSameValue("(")
						@tokenizer.advance
						#param list goes here
						if checkSameValue(")")
							return true
						end
					end
				end
			end
		end
		#
		return false
	end
	def compileParameterList()
		#
	end
	def compileVarDec()
		#
	end
	def compileStatements()
		#
	end
	def compileDo()
		#
	end
	def compileLet()
		#
	end
	def compileWhile()
		#
	end
	def compileReturn()
		#
	end
	def compileIf()
		#
	end
	def compileExpression()
		#
	end
	def compileTerm()
		#
	end
	def compileExpressionList()
		#
	end
end

if __FILE__ == $0 # this file was called for main
	puts "EXAMPLE USAGE:"
	a = CompilationEngine.new()
	
	# do shit
	
	
	
	
	
	
end
