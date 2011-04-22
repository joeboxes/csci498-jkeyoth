#!/usr/bin/ruby
require "Verbose.rb"

# KEY(NAME) | TYPE(INT/CHAR/..) | #(1,2,..)

class SymbolTable < Verbose
	def initialize(v=false)
		super(v)
		@hsh = Hash.new
		@index = 0
	end
	def clearTable
		@hsh.clear
		@index = 0
	end
	def addEntry(key,type)
		if @hsh[key]==nil
			@hsh[key] = Array.new(2)
			@hsh[key][0] = type
			@hsh[key][1] = @index
			@index = @index+1
		else
			printV("#{key}already in table\n")
		end
	end
	def getEntry(k)
		return @hsh[k]
	end
	def getIndex(k)
		return @hsh[k][1]
	end
	def getType(k)
		return @hsh[k][0]
	end
	def getLength
		return @index
	end
	def printTable
		if @hsh.length==0
			printV("SYMBOL TABLE: {EMPTY}")
		else
			printV("SYMBOL-TABLE: '\n")
			@hsh.each do |k,v|
				printV("  '#{k}' => '#{v[0]}' '#{v[1]}'\n")
			end
		end
	end
end


if __FILE__ == $0 # this file was called from command line
	puts "create new table (printing still follows printV -verbose- requirement)\n"
	symTbl = SymbolTable.new(true)
	puts "add some objects\n"
	symTbl.addEntry("nameID","int")
	symTbl.addEntry("username","int")
#	symTbl.setKeyValue("b","B")
#	symTbl.setKeyValue("c","C")
#	symTbl.setKeyValue("...","DOT DOT DOT")
#	symTbl.setKeyValue(666,999)
	
	puts "print table\n"
	symTbl.printTable
	
	puts "get values\n"
	obj = symTbl.getType("nameID")
	puts "type: #{obj}\n"
	obj = symTbl.getIndex("nameID")
	puts "index: #{obj}\n"
	obj = symTbl.getType("username")
	puts "type: #{obj}\n"
	obj = symTbl.getIndex("username")
	puts "index: #{obj}\n"
	
	
	puts "clear table\n"
	symTbl.clearTable
	puts "print table\n"
	symTbl.printTable
end
