#!/usr/bin/ruby
#JackTokenizer.rb Verbose
require "Verbose.rb"

class JackTokenizer < Verbose
# class vars



# instance vars
	def initialize(v=false)
		super(v)
		@fileJack = nil
		@fileXML = nil
	end
	def openFile(name)
		if name.length<1
			printV("file name length: #{name.length}\n")
			return
		end
		closeFile()# finish last job before starting new one
		jackName = name
		xmlName = getBase(name)+".xml"
		@fileJack = open(jackName,"r")
		@fileXML = open(xmlName,"w+")
		if @fileJack != nil && @fileXML != nil
			return true
		end
		return false
	end
	def closeFile()
		if @fileJack != nil
			@fileJack.close()
			@fileJack = nil
			printV("closed jack file handle\n")
		end
		if @fileXML != nil
			@fileXML.close()
			@fileXML = nil
			printV("closed XML file handle\n")
		end
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
	def open(name,opt)
		fHandle = nil
		if opt == "w" || opt == "w+"
			if File.file?(name)
				printV("file #{name} exists, opening...\n")
				fHandle = File.open(name,"w+")
			else
				printV("file #{name} does not exist, creating...\n")
				fHandle = File.new(name, "w+")
			end
		elsif opt == "r"
			fHandle = File.open(name,"r")
			if fHandle == nil
				printV("could not open #{name} for reading\n")
			else
				printV("opened #{name} for reading...\n")
			end
		end
		return fHandle;
	end
	def getBase(name)
		rev = (name.reverse)[/[^.]*/] # find location of '.' from end
		len = rev.length+1
		if len>name.length
			len = 0
		end
		ret = name[0,name.length-len]
		return ret
	end
end

if __FILE__ == $0 # this file was called for main
	puts "EXAMPLE USAGE:"
	a = JackTokenizer.new(true)
	ret = a.openFile("Main.jack")
	if ret==true
		puts "opened files successfully"
	else
		puts "problem opening files"
	end
	# do shit
	
	
	
	
	
	
end



