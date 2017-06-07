require 'factory_girl'
require "faker"

FactoryGirl.define do
	
	factory :category, class: 'Category' do

		title     { Faker::Job.field }

		trait :with_place do
			transient do
				place_count 4
			end

			after(:build) do |category, props|
				category.places << build_list(:place, props.place_count)
			end
		end
	end

end