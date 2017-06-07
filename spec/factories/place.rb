require 'factory_girl'
require "faker"

FactoryGirl.define do
	
	factory :place, class: 'Place' do

		formatted_address     { Faker::Address.full_address }
		icon                  { Faker::Placeholdit.image }
		id                    { Faker::Crypto.sha1 }
		name                  { Faker::Company.name }
		types                 { create_array Faker::Company, 4, :industry  }
		geometry              { {'location' => create_point, 
								  'viewport' => { "northeast" => create_point,
								  					 "southwest" => create_point }} }
		location              { create_array Faker::Address, 3, :city  }
		opening_hours         { Availability.new({:open_now => Faker::Boolean.boolean, 
													:weekdays_text => create_array(Faker::Time, 3, :backward) }) }
		place_id              { Faker::Crypto.sha1 }
		reference             { Faker::Crypto.sha256 }

	end


end

def create_array faker, amount, msg
	amount.times.collect { faker.send(msg) }
end

def create_point
	Point.new([Faker::Address.latitude, Faker::Address.longitude])
end