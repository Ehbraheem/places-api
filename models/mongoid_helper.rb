module MongoidHelper

	def mongoizer object, key
		case object
		when self then object.mongoize
		when Hash then
			if object[:type]
				self.new(object[key]).mongoize
			else 
				self.new(object).mongoize
			end

		else object
		end		
	end

	def demongoizer object, key
		self.new(object[key])
	end

	def evolve object
		case object 
		when self then object.mongoize
		else object
		end
	end

end