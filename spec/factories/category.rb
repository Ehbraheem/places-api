require 'factory_girl'
require "faker"


FactoryGirl.define do
	
	factory :category, class: 'Category' do

		title     { Faker::Job.field }

		# association :location
		# association :place

		trait :with_title do
			
		end

		trait :with_invalid_field do
			title        nil
		end

		trait :with_place do
			transient do
				place_count 4
			end

			after(:save) do |category, props|
				puts category
				category.places=(build_list(:place, props.place_count))
			end
		end
	end

end