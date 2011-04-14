#!/usr/bin/ruby
#RichieAnalyzer.rb Verbose
require "Verbose.rb"
require "RichieTokenizer.rb"
require "CompilationEngine.rb"
require "rubygems"
require "builder"

class RichieAnalyzer < Verbose
	def initialize(v=false)
		super(v)
		@tokenizer = RichieTokenizer.new()
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
		@tokenizer.openFile(inFile)
		@fileXML = @tokenizer.getXMLFile()
		@xmlBuilder = Builder::XmlMarkup.new(:target => @fileXML, :indent => 2)
		printXml
		@tokenizer.closeFile()
	end
	
	def printXmlToken(type)
		if type == RichieTokenizer.TYPE_KEYWORD
			val = @tokenizer.keyword
			@xmlBuilder.keyword " #{val} "
			printV("keyword: '#{val}'\n")
		elsif type == RichieTokenizer.TYPE_SYMBOL
			val = @tokenizer.symbol
			@xmlBuilder.symbol " #{val} "
			printV("symbol: '#{val}'\n")
		elsif type == RichieTokenizer.TYPE_IDENTIFIER
			val = @tokenizer.identifier
			@xmlBuilder.identifier " #{val} "
			printV("identifier: '#{val}'\n")
		elsif type == RichieTokenizer.TYPE_STRING
			val = @tokenizer.stringVal()
			@xmlBuilder.stringConstant " #{val} "
			printV("string: '#{val}'\n")
		elsif type == RichieTokenizer.TYPE_INT
			val = @tokenizer.intVal
			@xmlBuilder.integerConstant " #{val} " #.to_s
			printV("int: '#{val}'\n")
		else
			printV("unknown type'\n")
		end
		
	end
	
	def printXml()
		@xmlBuilder.tokens {
			@tokenizer.resetIndex
			@tokenizer.advance # go to first
			while @tokenizer.hasMoreTokens()
				type = @tokenizer.tokenType()
				printXmlToken type
				@tokenizer.advance
			end
		}
	end
	
end

if __FILE__ == $0 # this file was called from command line
	analyzer = RichieAnalyzer.new()
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

