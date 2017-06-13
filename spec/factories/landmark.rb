require 'factory_girl'

FactoryGirl.define do
	
	factory :landmark do
		
		association :location

		association :category

		trait :with_invalid_field do
			location_id        nil
			category_id		   nil
		end

		trait :with_location do
			:location
		end

		trait :with_category do
			:category
		end
	end
end