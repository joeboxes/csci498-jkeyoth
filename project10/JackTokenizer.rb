#!/usr/bin/ruby
#JackTokenizer.rb Verbose
require "Verbose.rb"

class JackTokenizer < Verbose
	def initialize(v=false)
		@verbose=v
	end
	def hasMoreTokens()
		return false
	end
	def advance()
		#
	end
	def tokenType()
		#
	end
	def keyWord()
		#
	end
	def symbol()
		#
	end
	def identifier()
		#
	end
	def intVal()
		#
	end
	def stringVal()
		#
	end
end

if __FILE__ == $0 # this file was called for main
	puts "EXAMPLE USAGE:"
	a = JackTokenizer.new()
	
	# do shit
	
	
	
	
	
	
end
