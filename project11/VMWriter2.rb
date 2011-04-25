#!/usr/bin/ruby
require "Verbose.rb"
require "SymbolTable.rb"
require "rubygems"
require "ruby-debug"
require "tree"

class VMWriter2 < Verbose
	def initialize(jackFileName, v=false)
		super(v)
		@verb = v
		
		vmFileName = File.basename(jackFileName, ".jack") + ".vm";
		@vmFile = File.open( vmFileName, "w")
	end
	
	def writePush(segment, index)
		@vmFile.write("push #{segment} #{index}\n")
	end
	def writePop(segment, index)
		@vmFile.write("pop #{segment} #{index}\n")
	end
	
	def writeCall(cls, sub, params)
		@vmFile.write("call #{cls}.#{sub} #{params}\n")
	end
	
	def writeFunction(cls, functName, numVars)
		@vmFile.write("function #{cls}.#{functName} #{numVars}\n")
	end
	
	def writeArithmetic(com)
		@vmFile.write(com + "\n")
	end
	
	def writeLabel(label)
		@vmFile.write("label #{label}\n")
	end
	
	def writeGoto(label)
		@vmFile.write("goto #{label}\n")
	end
	
	def writeIf(label)
		@vmFile.write("if-goto #{label}\n")
	end
	
	def writeReturn()
		@vmFile.write("return\n")
	end

	
	
	def close()
		@vmFile.close
	end
	
	def setVerbose(v)
		@verbose=v
	end

end