require "spec_helper"
require_relative File.absolute_path "./models/point.rb"


RSpec.describe "Points" do
	
	let(:point) { Point.new([23, 45]) }

	describe "valid object" do

		it "not nil" do
			# byebug
			expect(point).to_not be_nil
			expect(point.nil?).to eq false
		end

		it "has no methods" do
			method = point.methods false
			expect(method).to eq []
			expect(method).to be_empty
		end

		it "respond to getter methods" do
			expect(point).to respond_to :lng
			expect(point).to respond_to :lat
		end

		it "does not respond to setter methods" do
			expect(point).to_not respond_to :lat=
			expect(point).to_not respond_to :lng=
		end
	end

	describe "to MongoDB transformation" do
		
		it "can convert to MongoDB representation" do
			expect(point).to respond_to :mongoize
			expect(point.mongoize).to have_key :type
			expect(point.mongoize[:type]).to eq point.class.name
			# expect(point.mongoize).to 
		end

		it "has important .methods for transformation" do
			expect(Point).to respond_to :mongoize
			expect(Point).to respond_to :demongoize
			expect(Point).to respond_to :evolve
		end

		it "can tranform any form to MongoDB form" do
			point_object = point
			hash_object = {:type => point.to_s, :coordinates => point.to_a}
			nil_object = nil

			expect(Point.mongoize(hash_object)).to eq point.mongoize
			expect(Point.mongoize(point)).to eq point.mongoize
			expect(Point.mongoize(nil_object)).to eq nil
		end

		it "can tranform MongoDB for form to object form" do
			expect(Point.demongoize(point.mongoize).lat).to eq point.lat
			expect(Point.demongoize(point.mongoize).lng).to eq point.lng
		end
	end

	# descibe "can be passed to"
end