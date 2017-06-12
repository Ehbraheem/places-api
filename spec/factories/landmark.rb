require 'factory_girl'

FactoryGirl.define do
	
	factory :landmark do
		
		association :location

		association :category
	end
end