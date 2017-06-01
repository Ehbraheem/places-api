class Point

	attr_reader :lng, :lat

	def initialize(arr)
		@lat, @lng = arr
	end

	def to_a
		[@lat, @lng]
	end

	def mongoize
		{type: self.class.name, coordinates: self.to_a}
	end

	def self.mongoize object
		case object
		when Point then object.mongoize
		when Hash then
			if object[:type] # GeoJSON format
				Point.new(object[:coordinates]).mongoize
			else
				Point.new(object.values).mongoize
			end
		else object
		end
	end

	def self.demongoize object
		Point.new(object[:coordinates])
	end

	def self.evolve object
		case object 
		when Point then object.mongoize
		else object
		end
	end

end