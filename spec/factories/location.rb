require 'factory_girl'
require "faker"

FactoryGirl.define do
	
	factory :location, class: 'Location' do
		name     { Faker::Address.city }

		trait :with_name do
			
		end

		trait :with_invalid_field do
			name        nil
		end

		trait :with_category do
			transient do
				category_count 4
			end
			
			after(:build) do |location, props|
				location.categories << FactoryGirl.build_list(:category, props.category_count, :with_place)
			end
		end
	end

end