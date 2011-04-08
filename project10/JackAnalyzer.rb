#!/usr/bin/ruby
#JackAnalyzer.rb Verbose
require "Verbose.rb"
require "JackTokenizer.rb"
require "CompilationEngine.rb"

class JackAnalyzer < Verbose
	def initialize(v=false)
		super(v)
	end
	def hasMoreTokens()
		return false
	end
	
end

if __FILE__ == $0 # this file was called from command line
	analyzer = JackAnalyzer.new()
	tokenizer = JackTokenizer.new()
	engine = CompilationEngine.new()
	
	if ARGV.length < 1 # only accept with arguments
		puts "usage:\n#{$0} file_name.jack [-v]\n#{$0} directory_to_jack_files [-v]\n[-v for verbose]"
	else # at least single argument
		if ARGV.length>1 # 2nd argument =?= verbose
			if ARGV[1].downcase == "-v" # be verbose about everything
				analyzer.setVerbose(true)
				tokenizer.setVerbose(true)
				engine.setVerbose(true)
			end
		end
		if (ARGV[0] =~ /.*.jack/) # ends in ".jack" => file
			analyzer.printV("single file translation\n")
			tokenizer.openFile(ARGV[0])
			tokenizer.closeFile()
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
						tokenizer.openFile(e)
						tokenizer.closeFile()
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

