class Availability

	attr_reader :open_now, :weekdays_text

	def initialize(hash)
		return if hash.nil? 
		@open_now, @weekdays_text = hash.values
	end

	def mongoize
		{type: self.class.name, opening_hours: {open_now: @open_now, weekdays_text: @weekdays_text}}
	end

	def self.mongoize object
		case object
		when Availability then object.mongoize
		when Hash then
			if object[:type]
				Availability.new(object[:opening_hours]).mongoize
			else 
				Availability.new(object).mongoize
			end

		else object
		end		
	end

	def self.demongoize object
		Availability.new(object[:opening_hours])
	end

	def self.evolve object
		case object 
		when Availability then object.mongoize
		else object
		end
	end
end