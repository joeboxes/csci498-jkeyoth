#!/usr/bin/ruby
#CompilationEngine.rb Verbose
require "Verbose.rb"

class CompilationEngine < Verbose
	def initialize(v=false)
		@verbose=v
	end
	def compileClass()
		return false
	end
	def compileClassVarDec()
		#
	end
	def compileSubroutine()
		#
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
