class Point

	attr_reader :lng, :lat

	def initialize(**hash)
		@lat, @lng = hash
	end

end