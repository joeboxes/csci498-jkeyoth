#!/usr/bin/ruby
require "Verbose.rb"
require "SymbolTable.rb"
require "tree"

class VMWriter < Verbose
	def initialize(v=false)
		super(v)
		@verb = v
		@root = nil
		@staticTable = SymbolTable.new(v)#class scope
		@fieldTable = SymbolTable.new(v)#class scope
		@argumentTable = SymbolTable.new(v)#method scope
		@varTable = SymbolTable.new(v)#method scope
		@functionTable = SymbolTable.new(v)#class scope
		
		@firstStatements = true
		
		@curFunctName
		@curFunctType
		@curFunctNumVars
		
	end
	
	def setVerbose(v)
		@verbose=v
		@staticTable.setVerbose(v)
		@fieldTable.setVerbose(v)
		@argumentTable.setVerbose(v)
		@varTable.setVerbose(v)
		@functionTable.setVerbose(v)
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
	
	def setRoot(r)
		@root = r
	end
	
	def writeCode(jackFileName)
		vmFileName = File.basename(jackFileName, ".jack") + ".vm";
		@vmFile = File.open( vmFileName, "w")
		if @vmFile==nil
			return false
		end
		printV("generating VM code to #{vmFileName}")
		#		puts "#{@root.content.hasVal?}\n"
		#		puts "#{@root.content.name}\n"
		#		puts "#{@root.content.value}\n"
		#		puts ""
		#@root.children
		#hasVal==true => terminal
		
		iterateNode(@root)
		
		@vmFile.close
		return true
	end
	
	
	
	def iterateNode(node)
		#puts "#{node.content.name}\n"
		if node.content.name == "class"
			handleClass(node)
		elsif node.content.name == "classVarDec"
			handleClassVarDec(node)
		elsif node.content.name == "subroutineDec"
			handleSubDec(node)
		elsif node.content.name == "parameterList"
			handleParamList(node)
		elsif node.content.name == "varDec"
			handleVarDec(node)
		elsif node.content.name == "statements"
			handleStatements(node)
		end
		#puts "<#{node.content.name}>"
		if node.content.hasVal? #terminal, print val and go back up
			#puts " #{node.content.value} "
			#puts "</#{node.content.name}>\n"
			
		else #non terminal, keep going
			#puts "\n" 
			kids = node.children
			for kid in kids
				iterateNode(kid)
			end
			#puts "</#{node.content.name}>\n"
		end
	end
	
	def handleClass(node)
		
		@staticTable.clearTable
		@fieldTable.clearTable
		@className = node.children[1].content.value
	end
	
	def handleClassVarDec(node)
		arr = node.children
		if arr.length>1
			varType = arr[0].content.value
			type = arr[1].content.value
			st = nil
			if varType == "field"
				st = @fieldTable
			elsif varType == "static"
				st = @staticTable
			end
			if st!=nil
				i = 2
				while i<arr.length
					if arr[i].content.value!="," && arr[i].content.value!=";"
						st.addEntry(arr[i].content.value,type)
					end
					i = i + 1
				end
			end
			
			printV("\n")
			@staticTable.printTable
			@fieldTable.printTable
			printV("\n")
		end
	end
	
	def handleSubDec(node)
		@argumentTable.clearTable
		@varTable.clearTable
		arr = node.children
		type = arr[0].content.value
		name = arr[2].content.value
		@functionTable.addEntry(name, type)
		
		@firstStatements = true
		
		@curFunctName = name
		@curFunctType = type
		
		@functionTable.printTable
	end
	
	def handleParamList(node)
		arr = node.children
		i = 0
		while i<arr.length
			@argumentTable.addEntry(arr[i+1].content.value,arr[i].content.value)
			i = i+3
		end
		@argumentTable.printTable
	end
	
	def handleVarDec(node)
		arr = node.children
		if arr.length>2
			varType = arr[0].content.value
			type = arr[1].content.value
			if varType == "var"
				i = 2
				while i<arr.length
					if arr[i].content.value!="," && arr[i].content.value!=";"
						@varTable.addEntry(arr[i].content.value,type)
					end
					i = i + 1
				end
			end
		end
		@curFunctNumVars = @varTable.getLength
		@varTable.printTable
	end
	
	def handleStatements(node)
		if @firstStatements
			if @curFunctType == "constructor"
				writeConstructor
			end
			@firstStatements = false
		end
		#continue with handling the statements
	end
	
	
	def writeConstructor()
		numVars = @fieldTable.getLength
		@vmFile.write("function #{@className}.#{@curFunctName} #{numVars}\n")
		writePush("constant", @curFunctNumVars)
		writeCall("Memory", "alloc", 1)
		writePop("pointer", 0)
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
	
	
end


if __FILE__ == $0 # this file was called from command line
	puts "how to \n"
	
end
# return Tree::TreeNode.new(name + getNextName, ParseNode.new(name, parseVal))
