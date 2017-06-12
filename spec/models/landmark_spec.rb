require "spec_helper"

RSpec.describe Landmark, type: :model, orm: :active_record do 

	include_context "db_cleanup_each"

	describe Category do
		
		context "build valid Landmark" do

			it_should_behave_like "build valid object", [:landmark, ["location_id", "category_id"]]

		end

		context "build invalid Landmark" do

			it_should_behave_like "build invalid object", [:landmark, ["location_id", "category_id"]]

		end
	end

	describe "Relationship" do

		it_should_behave_like "Associations", [:category, "location", "category"]
		
	end

	describe "Cannot persist when associations are invalid" do
		
		let(:record) { FactoryGirl.build(:landmark, :location=>nil) }

		context "save fails for invalid location" do
			
			it "rollback save for invalid location" do
				expect(record.save).to be false
				expect(record.location).to be nil
				expect(record.category).to_not be nil
				expect(record).to_not be nil
			end

			it "provide descriptive error messages" do
				expect(record).to respond_to :errors
				expect(record.errors).to_not be nil
				expect(record.errors.messages).to_not be nil
				expect(record.errors).to respond_to :full_messages
				expect(record.errors.messages).to include /invalid/
			end

			it "failed to save record with invalid location" do
				expect(record.save).to be false
				expect(record.errors.messages).to match /location is not valid/
			end
		end
	end


	describe "Act as proxy" do
		
		context "belongs to Location" do

			let(:fail_record) { FactoryGirl.build(:landmark) }
			let(:record) { FactoryGirl.build(:landmark)}
			
			it "save fails when location is nil" do

				expect(fail_record.save).to be false
				expect(fail_record).to respond_to :errors
				expect(fail_record.errors).to respond_to :messages
				expect(fail_record.errors).to respond_to :full_messages
				expect(fail_record.errors.messages).to include :location=> ["can't be blank"]
			end

			it "it allow multiple document to have same location" do
				record.save
				another_record = FactoryGirl.create_list(:landmark, 10, :location=>record.location)
				another_record.each do |land|
					expect(land.location).to eq record.location
					expect(land.location_id).to eq record.location_id
					expect(land.category).to_not eq record.location
					expect(land.category_id).to_not eq record.category_id
				end
			end

			it "index location"

		end

		context "belongs to Category" do

			it "save fails when location is nil"

			it "it allow multiple document to have same location"

			it "index location"

		end

	end

	describe "Act as bridge" do

		let(:location) { FactoryGirl.create(:location) }
		let(:records)  { FactoryGirl.create_list(:landmark, 10, :location=>location) }
		
		context "from location to Category" do
			
			it "allow access to category from Location" do
				expect(location).to respond_to :categories
				expect(location.categories.to_a).to be_a_kind_of Array
				expect(location.categories).to respond_to :length
				expect(location.categories).to respond_to :count
				expect(location.categories.count).to be > 1
				expect(location.categories.length).to be > 1
			end

			it "list out all categories for this location" do
				location.categories.each do |cat|
					expect(cat.landmark).to be_a_kind_of Landmark
					expect(cat.location).to eq location
					expect(Landmark.all).to include cat.landmark
				end
			end

			it "provides details of each category for this location" do
				location.categories.each do |cat|
					expect(cat).to respond_to :attributes
					Category.attributes.each do |attr|
						expect(cat).to respond_to attr.to_sym
						expect(cat).to have_attribute attr.to_sym
						expect(cat).to respond_to "#{attr}=".to_sym
					end
				end
			end

			it "verify same the same location for eaach category" do
				location.categories.each do |cat|
					Location.attributes.each do |attr|
						expect(cat.location).to respond_to attr.to_sym
						expect(cat.location).to respond_to "#{attr}=".to_sym

						sender = ->(obj, msg) { send_message obj, msg.to_sym }

						expect(sender.call(location, attr)).to eq sender.call(cat.location, attr) 

					end
				end
			end

		end

		context "from Category to location" do
			
			it "allow access to location from category"

			it "list out all locations for this categories"

			it "provides details of each location for this category"

		end

	end
	
end