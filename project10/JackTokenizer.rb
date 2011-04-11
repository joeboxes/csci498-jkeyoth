#!/usr/bin/ruby
#JackTokenizer.rb Verbose
require "Verbose.rb"

class JackTokenizer < Verbose
# class vars

	KEYWORDS=["class", "method", "function", "constructor", "int",\
			"boolean", "char", "void", "var", "static", "field",\
			"let", "do", "if", "else", "while", "return", "true",\
			"false", "null", "this"]
	
	SYMBOLS="{([])}.,;+-*/&|<>=~"
	
	
	

# instance vars
	def initialize(v=false)
		super(v)
		@fileJack = nil
		@fileXML = nil
		@line = ""
		@multiComment = false
		@fileObjects = nil
		@curTokenNum = -1
		@curToken = nil
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
	
	def getOutFile()
		return @fileXML
	end
	
	def parseJack()
		if @fileJack == nil
			return
		end
		inComment = false
		@fileObjects = Array.new()
		@fileJack.each do |line|
			line = cleanUpInputLine(line)
			if line.length>0 # reject blank lines
				a = Array.new()
				a = line.split(/[\s]/)
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
							b = Array.new()
							b = obj.split(/([\s{}()\[\].,;+*\/&|<>=~"-])/)
							b.each do |obj2| # push to global array
								if obj2.length>0 # reject blank lines
									if obj2 != ' '
										@fileObjects.push(obj2)
									end
								end
							end
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
	
	def cleanUpInputLine(line)
		line.chomp!
		line.gsub!("\t","") # remove all tabs
		line.gsub!(/\/\/.*/,"")
		line.strip!
		line.squeeze!(" ") # set spacing between words to single space
		return line
	end
	
	def hasMoreTokens()
		return @curTokenNum < @fileObjects.length
	end
	def advance()
		@curTokenNum = @curTokenNum + 1
		if hasMoreTokens()
			@curToken = @fileObjects[@curTokenNum]
		end
	end
	def tokenType()
		if KEYWORDS.count(@curToken) > 0
			return "KEYWORD"
		elsif SYMBOLS.count(@curToken) > 0
			return "SYMBOL"
		elsif @curToken =~ /^[0-9]+$/
			return "INT_CONST"
		elsif @curToken[0] == "\"" and @curToken[-1] == "\""
			return "STRING_CONST"
		else
			return "IDENTIFIER"
		end
	end
	def keyword()
		if tokenType() == "KEYWORD"
			return @curToken
		end
	end
	def symbol()
		if tokenType() == "SYMBOL"
			return @curToken
		end
	end
	def identifier()
		if tokenType() == "IDENTIFIER"
			return @curToken
		end
	end
	def intVal()
		if tokenType() == "INT_CONST"
			return Integer(@curToken)
		end
	end
	def stringVal()
		if tokenType() == "STRING_CONST"
			return @curToken[1..-2]
		end
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



