#!/usr/bin/ruby
#Verbose.rb
#provides the ability to choose verbose

class Verbose
	def initialize
		@verbose=false
	end
	def setVerbose(v)
		@verbose=v
	end
	def getVerbose()
		return @verbose
	end
	def printV(s)
		if @verbose
			print(s)
		end
	end
end

if __FILE__ == $0
	puts "EXAMPLE USAGE:"
	v = Verbose.new()
	v.printV("nonverbose mode\n")
	v.setVerbose(true)
	v.printV("verbose mode\n")
end
