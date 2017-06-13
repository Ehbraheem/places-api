require File.expand_path "../../spec_helper.rb", __FILE__
# require_relative File.absolute_path "./models/availability.rb"

RSpec.describe "Availability", :type => :model do
	

	it_should_behave_like "Custom DB type", :availability

	it_should_behave_like "tranform custom type to DB type", Availability.new({open_now: true, weekdays_text: []})

	it_should_behave_like "Valid type", :availability, ["open_now", "weekdays_text"]

	describe "to MongoDB transformation" do

		let(:availability) { Availability.new({:open_now=> true, :weekdays_text=> []}) }
		
		it "tranform MongoDB form to Availability form" do
			object = Availability.demongoize(availability.mongoize)
			expect(object.open_now).to eq availability.open_now
			expect(object.weekdays_text).to eq availability.weekdays_text
		end
	end

end