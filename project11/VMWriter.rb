#!/usr/bin/ruby
require "Verbose.rb"
require "SymbolTable.rb"
require "tree"

class VMWriter < Verbose
	def initialize(v=false)
		super(v)
		@root = nil
		@staticTable = SymbolTable.new(v)
		@fieldTable = SymbolTable.new(v)
		@argumentTable = SymbolTable.new(v)
		@varTable = SymbolTable.new(v)
	end
	def setVerbose(v)
		@verbose=v
		@staticTable.setVerbose(v)
		@fieldTable.setVerbose(v)
		@argumentTable.setVerbose(v)
		@varTable.setVerbose(v)
	end
	def setRoot(r)
		@root = r
	end
	def writeCode(jackFileName)
		vmFileName = File.basename(jackFileName, ".jack") + ".vm";
		vmFile = File.open( vmFileName, "w")
		if vmFile==nil
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
		
		
		
		
		
		
		
		
		
		
		vmFile.close
		return true
	end
	def iterateNode(node)
		#puts "#{node.content.name}\n"
		if node.content.name == "class"
			@staticTable.clearTable
			@fieldTable.clearTable
		elsif node.content.name == "classVarDec"
			arr = getArrayFromChildren(node.children)
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
		elsif node.content.name == "subroutineDec"
			@argumentTable.clearTable
			@varTable.clearTable
		elsif node.content.name == "parameterList"
			arr = getArrayFromChildren(node.children)
			i = 0
			while i<arr.length
				@argumentTable.addEntry(arr[i+1].content.value,arr[i].content.value)
				i = i+3
			end
			@argumentTable.printTable
		elsif node.content.name == "varDec"
			arr = getArrayFromChildren(node.children)
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
			@varTable.printTable
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
		def getArrayFromChildren(kids)
			arr = Array.new
			i = 0
			for kid in kids
				arr[i] = kid
				i = i + 1
			end
			return arr
		end
	end
end


if __FILE__ == $0 # this file was called from command line
	puts "how to \n"
	
end
# return Tree::TreeNode.new(name + getNextName, ParseNode.new(name, parseVal))




