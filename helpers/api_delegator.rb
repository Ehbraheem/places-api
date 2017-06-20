require 'httparty'

module ApiDelegator

	class Delegate

		GOOGLE_API = "https://maps.googleapis.com/maps/api/place/textsearch/json?query="
		
		def self.api_url query
			query.gsub!(/\s/, "+")
			GOOGLE_API + query + "&key=#{ENV['GOOGLE_KEY']}"
		end

		def self.get_data url
			HTTParty.get(url)["results"]
		end

		def self.save_data query
			@query, category, location = query
			@location = Location.with_name(location)
			@category = Category.with_title(category)
			unless !!(@location && @category)
				url = api_url(@query)
				data =  get_data(url)
				places_inserted = []
				if !data.empty?
					landmark = Landmark.create(:location=>Location.find_or_create_by(:name=>location), :category=>Category.find_or_create_by(:title=>category))
					data.each do |doc|
						doc.merge!(:category_id=> landmark.category_id)
						places_inserted << Place.new(doc).push(:location=>landmark.location_id).upsert
					end
				end
				return places_inserted.all? { |e| e }
			end
			true
		end
	end
end