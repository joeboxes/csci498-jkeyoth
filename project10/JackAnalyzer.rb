#!/usr/bin/ruby
#JackAnalyzer.rb Verbose
require "Verbose.rb"
require "JackTokenizer.rb"
require "CompilationEngine.rb"
require "rubygems"
require "builder"

class JackAnalyzer < Verbose
	def initialize(v=false)
		super(v)
		@tokenizer = JackTokenizer.new()
		@engine = CompilationEngine.new()
		@tokenizer.setVerbose(v)
		@engine.setVerbose(v)
		@fileXML = nil
		@xmlBuilder = nil
	end
	
	def setVerbose(v)
		@verbose = v
		@tokenizer.setVerbose(v)
		@engine.setVerbose(v)
	end
	
	def doFile(inFile)
		# parse input to array
		@tokenizer.openFile(inFile)
		@tokenizer.closeFile()
		#printXml(inFile)# only for checking
		# compile tokenizer array
		@engine.setTokenizer(@tokenizer)
		ret = @engine.compileClass()
		if ret
			printV("successful compilation\n")
		else
			puts "error occurred compiling file\n"
		end
	end
	
	def printXmlToken(type)
		if type == JackTokenizer.TYPE_KEYWORD
			val = @tokenizer.keyword
			@xmlBuilder.keyword " #{val} "
			printV("keyword: '#{val}'\n")
		elsif type == JackTokenizer.TYPE_SYMBOL
			val = @tokenizer.symbol
			@xmlBuilder.symbol " #{val} "
			printV("symbol: '#{val}'\n")
		elsif type == JackTokenizer.TYPE_IDENTIFIER
			val = @tokenizer.identifier
			@xmlBuilder.identifier " #{val} "
			printV("identifier: '#{val}'\n")
		elsif type == JackTokenizer.TYPE_STRING
			val = @tokenizer.stringVal()
			@xmlBuilder.stringConstant " #{val} "
			printV("string: '#{val}'\n")
		elsif type == JackTokenizer.TYPE_INT
			val = @tokenizer.intVal
			@xmlBuilder.integerConstant " #{val} " #.to_s
			printV("int: '#{val}'\n")
		else
			printV("unknown type'\n")
		end
		
	end
	
	def printXml(jackFileName)
		@fileXML = @tokenizer.getXMLFile(jackFileName)
		if @fileXML != nil
		@xmlBuilder = Builder::XmlMarkup.new(:target => @fileXML, :indent => 2)
		@xmlBuilder.tokens {
			@tokenizer.resetIndex # go to first
			while @tokenizer.hasMoreTokens()
				type = @tokenizer.tokenType()
				printXmlToken type
				@tokenizer.advance
			end
		}
			@fileXML.close()
			@fileXML = nil
			printV("closed XML file handle\n")
		end
	end
	
end

if __FILE__ == $0 # this file was called from command line
	analyzer = JackAnalyzer.new()
	if ARGV.length < 1 # only accept with arguments
		puts "usage:\n#{$0} file_name.jack [-v]\n#{$0} directory_to_jack_files [-v]\n[-v for verbose]"
	else # at least single argument
		if ARGV.length>1 # 2nd argument =?= verbose
			if ARGV[1].downcase == "-v" # be verbose about everything
				analyzer.setVerbose(true)
			end
		end
		if (ARGV[0] =~ /.*.jack/) # ends in ".jack" => file
			analyzer.printV("single file translation\n")
			analyzer.doFile(ARGV[0])
		else # ending not ".jack" => directory of files
			analyzer.printV("directory translation\n")
			if File.directory?(ARGV[0]) # directory exists
				Dir.chdir(ARGV[0])
				entries = Dir.glob("*.jack")
				if entries.length > 0 # at least one entry
					entries.each do |e| # files with .vm extension
						analyzer.doFile(e)
					end
				end
			else #directory does not exist
				puts "#{ARGV[0]} is not a directory"
			end
		end
	end
end

