class PlacesApi

	helpers do
		
		def create_route id, object
			send("#{object}_path", id)
		end

	end

end
