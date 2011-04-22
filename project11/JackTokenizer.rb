#!/usr/bin/ruby
#JackTokenizer.rb Verbose
require "Verbose.rb"

class JackTokenizer < Verbose
	# class vars
	@@KEYWORDS=["class", "method", "function", "constructor", "int",\
			"boolean", "char", "void", "var", "static", "field",\
			"let", "do", "if", "else", "while", "return", "true",\
			"false", "null", "this"]
	@@SYMBOLS= ["{", "(", "[", "]", ")", "}", ".", ",", ";", "+", "-", "*", "/", "&", "|", "<", ">", "=", "~"]
	
	
	@@TYPE_KEYWORD = "KEYWORD"
	@@TYPE_SYMBOL = "SYMBOL"
	@@TYPE_IDENTIFIER = "IDENTIFIER"
	@@TYPE_INT = "INT_CONST"
	@@TYPE_STRING = "STRING_CONST"
	@@TYPE_UNKNOWN = "TYPE_UNKNOWN"
	
	def self.KEYWORDS
		@@KEYWORDS
	end
	def self.SYMBOLS
		@@SYMBOLS
	end
	def self.TYPE_KEYWORD
		@@TYPE_KEYWORD
	end
	def self.TYPE_SYMBOL
		@@TYPE_SYMBOL
	end
	def self.TYPE_IDENTIFIER
		@@TYPE_IDENTIFIER
	end
	def self.TYPE_INT
		@@TYPE_INT
	end
	def self.TYPE_STRING
		@@TYPE_STRING
	end
	def self.TYPE_UNKNOWN
		@@TYPE_UNKNOWN
	end
	# instance vars
	def initialize(v=false)
		super(v)
		@fileJack = nil
		#		@fileXML = nil
		@line = ""
		@multiComment = false
		@fileObjects = nil
		@curTokenNum = -1
		@curToken = nil
	end
	def openFile(name)
		if name.length<1
			printV("file name length: #{name.length}\n")
			return false
		end
		closeFile()# finish last job before starting new one
		jackName = name
		@fileJack = open(jackName,"r")
		if @fileJack != nil
			return parseJack()
		end
		return false
	end
	def closeFile()
		if @fileJack != nil
			@fileJack.close()
			@fileJack = nil
			printV("closed jack file handle\n")
		end
	end
	
	def getJackFile()
		return @fileJack
	end
	
	def getXMLFile(fName)
		xmlName = getBase(fName)+".xml"
		fileXML = open(xmlName,"w+")
		return fileXML
	end
	
	def parseJack()
		if @fileJack == nil
			return false
		end
		singleObjects = Array.new()
		@fileJack.each do |line|
			splitLine = cleanUpInputLine(line)
			splitLine.each do |obj| # push to temporary array
				singleObjects.push(String(obj))
			end
		end
		
		inComment = false
		skipNext = 0
		@fileObjects = Array.new()
		i = 0
		while i < singleObjects.length # push to global array
			obj = singleObjects[i]
			if skipNext > 0
				skipNext = skipNext - 1
			else
				if inComment
					if obj == "*" # look ahead
						if singleObjects[i+1] == "/"
							inComment = false
							skipNext = 1
						end
					end
				else # not in comment
					if obj == "/" # look ahead
						if singleObjects[i+1] == "*"
							inComment = true
							skipNext = 1
						else
							@fileObjects.push(obj)
						end
					else
						@fileObjects.push(obj)
					end
				end
			end
			i = i + 1
		end
		return true
	end
	
	def splitButKeepStringConsts(line)
		splited = line.split(/([\"])/)
		putTogether = Array.new()
		curSpot = 0
		while curSpot < splited.length
			if splited[curSpot] == "\""
				putTogether.push(String(splited[curSpot,curSpot+2]))
				curSpot += 3
			else
				symbolSplit = splited[curSpot].split(/([\s{}()\[\].,;+*\/&|<>=~"-])/)
				symbolSplit.each do |toke|
					if toke.length > 0
						tokeArray = toke.split
						tokeArray.each do |toker|
							putTogether.push(toker.strip)
						end
						
					end
				end
				curSpot += 1
			end
		end
		return putTogether
	end
	
	def cleanUpInputLine(line)
		line.chomp! # remove end-of-line \n and \r
		line.gsub!("\t","") # remove all tabs
		line.gsub!(/\/\/.*/,"") # remove single line comments
		line.strip! # remove leading & trailing white space
		#		line.squeeze!(" ") # set spacing between words to single space - not for STRINGS
		splitLine = splitButKeepStringConsts(line);
		return splitLine
	end
	
	def hasMoreTokens()
		return @curTokenNum < @fileObjects.length
	end
	
	def resetIndex()
		@curTokenNum = -1
		advance
	end
	
	def advance()
		@curTokenNum = @curTokenNum + 1
		if hasMoreTokens()
			@curToken = @fileObjects[@curTokenNum]
		end
		printV("new token: #{@curToken}\n")
	end
	
	def peek()
		advance
		violated = getCurrItem
		retract
		return violated
	end
	
	def retract()
		@curTokenNum = @curTokenNum - 1
		if @curTokenNum < 0
			@curTokenNum = 0
		end
		if hasMoreTokens()
			@curToken = @fileObjects[@curTokenNum]
		end
	end
	
	def getItem(type)
		if type == JackTokenizer.TYPE_KEYWORD
			return keyword
		elsif type == JackTokenizer.TYPE_SYMBOL
			return symbol
		elsif type == JackTokenizer.TYPE_IDENTIFIER
			return identifier
		elsif type == JackTokenizer.TYPE_STRING
			return stringVal
		elsif type == JackTokenizer.TYPE_INT
			return intVal
		end
		return nil
	end
	
	def getCurrItem()
		return getItem(tokenType())
	end
	
	def getType(obj)
		#printV("#{@obj}:#{@@SYMBOLS.count(@obj)}\n")
		strVal = String(obj)
		beginning = strVal[0..0]
		ending = strVal[-1..-1]
		if beginning == "\"" && ending == "\""
			return @@TYPE_STRING
		elsif @@KEYWORDS.count(obj) > 0
			return @@TYPE_KEYWORD
		elsif @@SYMBOLS.count(obj) > 0
			return @@TYPE_SYMBOL
		elsif obj =~ /^[0-9]+$/
			return @@TYPE_INT
		elsif obj.class == Fixnum
			return @@TYPE_INT
		else
			return @@TYPE_IDENTIFIER
		end
	end
	
	def tokenType()
		return getType(@curToken)
	end
	
	def keyword()
		if tokenType() == @@TYPE_KEYWORD
			return @curToken
		end
		return @@TYPE_UNKNOWN
	end
	
	def symbol()
		if tokenType() == @@TYPE_SYMBOL
			return @curToken
		end
		return @@TYPE_UNKNOWN
	end
	
	def identifier()
		if tokenType() == @@TYPE_IDENTIFIER
			return @curToken
		end
		return @@TYPE_UNKNOWN
	end
	
	def intVal()
		if tokenType() == @@TYPE_INT
			return Integer(@curToken)
		end
		return @@TYPE_UNKNOWN
	end
	
	def stringVal()
		if tokenType() == @@TYPE_STRING
			str = @curToken[1...-2]
			return str
		end
		return @@TYPE_UNKNOWN
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
end
