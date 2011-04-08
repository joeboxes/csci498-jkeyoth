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
		@line = ""
		@multiComment = false
		@fileObjects = nil
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
			parseJack()
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
	def parseJack()
		if @fileJack == nil
			return
		end
		inComment = false
		@fileObjects = Array.new()
		@fileJack.each do |line|
			line = line.gsub("\n","") # remove all newlines
			line = line.gsub("\r","") # remove all returns
			line = line.gsub("\t","") # remove all tabs
			line = line.gsub(/\/\/.*/,"") # remove all single-line comments
			line = line.rstrip # remove trailing white space
			line = line.lstrip # remove leading white space
			line = line.squeeze(" ") # set spacing between words to single space
			if line.length>0 # reject blank lines
				a = Array.new()
				a = line.split(" ")
				a.each do |obj| # push to global array
					if inComment # look for comment end /* .. */
						ind = obj.index(/\*\//)
						if ind == nil
							#@fileObjects.push(obj)
						else
							inComment = false
						end
					else # look for comment beginning
						ind = obj.index(/\/\*/)
						if ind == nil
							@fileObjects.push(obj)
						else
							inComment = true
						end
					end
					
				end
			end
		end
		@fileObjects.each do |obj| # push to global array
			printV("'#{obj}'")
			printV("\n")
		end
		
	end
	def hasMoreTokens()
		return false
	end
	def advance()
		@line = @fileJack.gets()
		return @line
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
			if File.exists?(name)
				fHandle = File.open(name,"r")
				if fHandle == nil
					printV("could not open #{name} for reading\n")
				else
					printV("opened #{name} for reading...\n")
				end
			else
				printV("file #{name} does not exist");
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



