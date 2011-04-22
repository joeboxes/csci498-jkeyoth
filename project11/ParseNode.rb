
class ParseNode

	def initialize(n, v=nil)
		@name = n
		@value = v
	end
	
	def name()
		return @name
	end
	
	def value()
		return @value
	end
	
	def hasVal?
		return @value != nil
	end
end
