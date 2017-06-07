require 'factory_girl'
require "faker"

FactoryGirl.define do
	
	factory :location, class: 'Location' do
		name     { Faker::Address.city }

		trait :with_category do
			transient do
				category_count 4
			end

			after(:build) do |location, props|
				location.categories << build_list(:category, props.category_count)
			end
		end
	end

end