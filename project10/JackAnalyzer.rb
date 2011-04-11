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
		
	end
	
	def doFile(inFile)
		@tokenizer.openFile(inFile)
		@fileXML = @tokenizer.getOutFile
		#while (s = tokenizer.advance())
		#	analyzer.printV("'#{s}'\n")
		#end
		
		@fileXML = @tokenizer.getOutFile
		@xmlBuilder = Builder::XmlMarkup.new(:target => @fileXML, :indent => 2)
		
		printXml
		
		@tokenizer.closeFile
	end
	
	def printXmlToken(type)
		if type == "KEYWORD"
			val = @tokenizer.keyword
			@xmlBuilder.keyword val
		elsif type == "SYMBOL"
			val = @tokenizer.symbol
			@xmlBuilder.symbol val
		elsif type == "IDENTIFIER"
			val = @tokenizer.identifier
			@xmlBuilder.identifier val
		elsif type == "STRING_CONST"
			val = @tokenizer.stringVal
			@xmlBuilder.string_const val
		elsif type == "INT_CONST"
			val = @tokenizer.intVal
			@xmlBuilder.int_const val
		end
		
	end
	
	def printXml()
		@xmlBuilder.tokens {
			while @tokenizer.hasMoreTokens
				@tokenizer.advance
				type = @tokenizer.tokenType
				printXmlToken type
			
			end
		}
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
				analyzer.printV("---------------------------------------\n")
				analyzer.printV("list of files matching .jack extension:\n")
				Dir.chdir(ARGV[0])
				entries = Dir.glob("*.jack")
				if entries.length > 0 # at least one entry
					entries.each do |e| # files with .vm extension
						analyzer.printV("#{e}: \n")
						analyzer.doFile(e)
					end
					#cW.close()
					analyzer.printV("\n")
				end
			else #directory does not exist
				puts "#{ARGV[0]} is not a directory"
			end
		end
	end
	
	
	
end

# http://ruby-doc.org/core/

