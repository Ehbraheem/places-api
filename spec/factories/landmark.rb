require 'factory_girl'

FactoryGirl.define do
	
	factory :landmark do
		
		association :location

		association :category

		trait :with_invalid_field do
			location_id        nil
			category_id		   nil
		end
	end
end