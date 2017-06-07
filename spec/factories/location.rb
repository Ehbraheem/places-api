require 'factory_girl'
require "faker"

FactoryGirl.define do
	
	factory :location, class: 'Location' do
		name     { Faker::Address.city }

		trait :with_category do
			categories { 2.times { Faker::Job.field } }
		end
	end

end