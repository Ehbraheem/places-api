require "spec_helper"
require_relative File.absolute_path "./models/point.rb"


RSpec.describe "Points" do
	
	let(:point) { Point.new }

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

	# descibe "can be passed to"
end