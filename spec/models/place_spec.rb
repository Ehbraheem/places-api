require "spec_helper"
# require_relative File.absolute_path "./models/place.rb"
require_relative File.absolute_path "./models/point.rb"

RSpec.describe Place, :type => :model, :orm => :mongoid do

	include_context "db_cleanup_each"

	let(:point) { Point.new(nil).mongoize }
	let(:place) { Place.new }

	describe Place do
		
		context "should have all fields with default value of nil" do

			it { is_expected.to have_field(:formatted_address).of_type(String).with_default_value_of(nil) }

			it { is_expected.to have_field(:icon).of_type(String).with_default_value_of(nil) }

			it { is_expected.to have_field(:name).of_type(String).with_default_value_of(nil) }

			it { is_expected.to have_field(:place_id).of_type(String).with_default_value_of(nil) }

			it { is_expected.to have_field(:reference).of_type(String).with_default_value_of(nil) }

			it { is_expected.to have_field(:types).of_type(Array).with_default_value_of([]) }

			it { is_expected.to have_field(:location).of_type(Array).with_default_value_of([]) }

			it { is_expected.to have_field(:geometry).of_type(Hash).with_default_value_of point }

			it { is_expected.to have_field(:opening_hours).of_type(Availability).with_default_value_of(nil) }

			it { is_expected.to have_field(:rating).of_type(Float).with_default_value_of(0.0) }

			it { is_expected.to have_field(:_id).of_type(String) }

		end

	end

	describe "Validations" do

		
		context "instance with no fields" do
			
			it "is not valid" do
				expect(place).to_not be_valid
				expect(place.valid?).to be false
				expect(place._validators?).to be true
			end

			it "is not persisted" do
				expect(place.persisted?).to be false
				expect(place.id).to be_nil
			end

			it "cannot persist" do
				persisted = place.save

				expect(persisted).to be false
				expect(place.persisted?).to eq persisted
				expect(place.save).to eq persisted
			end
		end

		context "has nil fields" do
			
			it "set default value" do
				expect(place.formatted_address).to be_nil
				expect(place.rating).to eq 0.0
				expect(place._id).to be_nil
				expect(place.opening_hours).to be_nil
				expect(place.types).to be_empty
				expect(place.name).to be_nil
				expect(place.icon).to be_nil
				expect(place.reference).to be_nil
				expect(place.place_id).to be_nil
				expect(place.geometry).to eq point
				expect(place.location).to be_empty
			end
		end
	end

	describe "Validation errors" do

		let(:persisted) { place.save }


		context "cannot save instance with invalid field(s)" do
			it "prevent save for invalid instance" do
				expect(persisted).to be false
				expect(place.persisted?).to eq persisted
				expect(place.save).to eq persisted
			end

			it "instance has errors" do
				place.save
				expect(place).to respond_to :errors
				expect(place.errors).to respond_to :messages
				expect(place.errors).to respond_to :full_messages
				expect(place.errors.messages[:name]).to_not be_empty
				expect(place.errors.messages[:location]).to_not be_empty
				expect(place.errors.messages[:icon]).to_not be_empty
				expect(place.errors.messages[:reference]).to_not be_empty
				expect(place.errors.messages[:formatted_address]).to_not be_empty
				expect(place.errors.messages[:opening_hours]).to_not be_empty
			end

			it "has specific errors" do
				place.errors.messages.keys.each do |k|
					expect(place.errors.messages[k]).to eq ["can't be blank"]
				end
			end
		end

		context "cannot save unique instance with same value" do

			%w(name place_id geometry).each do |field|
				it_should_behave_like "duplicate field", field.to_sym
			end

			it_should_behave_like "duplicate of unique fields", [ :name, :place_id, :geometry ]

		end
		
	end

	describe "one Place to many category" do
		
		it_should_behave_like "many-to-one Association", [:place, :category]
		
	end



end