require "spec_helper"
require_relative File.absolute_path "./models/point.rb"


RSpec.describe "Points", :type => :model do
	

	it_should_behave_like "Custom DB type", :point

	it_should_behave_like "tranform custom type to DB type", Point.new([23, 45])

	it_should_behave_like "Valid type", :point, ["lat", "lng"]

	describe "to MongoDB transformation" do

		let(:point) { Point.new([23, 45]) }

		it "can tranform MongoDB for form to object form" do
			expect(Point.demongoize(point.mongoize).lat).to eq point.lat
			expect(Point.demongoize(point.mongoize).lng).to eq point.lng
		end

	end
end