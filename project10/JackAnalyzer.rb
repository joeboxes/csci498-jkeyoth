#!/usr/bin/ruby
#JackAnalyzer.rb Verbose
require "Verbose.rb"

class JackAnalyzer < Verbose
	def initialize(v=false)
		@verbose=v
	end
	def hasMoreTokens()
		return false
	end
	
end

if __FILE__ == $0 # this file was called for main
	puts "EXAMPLE USAGE:"
	a = JackAnalyzer.new()
	
	# do shit
	
	
	
	
	
	
end
