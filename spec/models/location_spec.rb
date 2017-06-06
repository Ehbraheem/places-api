require "spec_helper"

RSpec.describe Location, type: :model, orm: :active_record do

	# include_context "db_cleanup_each"

	describe Location do
		
		context "build valid Location" do

			let(:location) { FactoryGirl.build(:loc) }
			
			it "default Location created with random name" do
				expect(location).to_not be_nil
				expect(location).to be_a_kind_of Location
				expect(location).to have_field :name
				expect(location).to respond_to :name
				expect(location).to respond_to :name=
			end

			it "create Location with non-nil name"

			it "create Location with non-nil category" do
				expect(location).to_not be_nil
				expect(location.name).to_not be_empty
				expect(location.name.length).to be > 1
				expect(location.name).to include /[a-z]/i
			end

		end

		context "build invalid Location" do

			let(:location) { FactoryGirl.build(:loc, :name=>nil) }
			
			it "fails to validate" do
				expect(location.name).to be_nil
				expect(location).to_not be_valid
			end

			it "fails to save" do
				expect(location.save).to be false
				expect(location).to have_field :errors
				expect(location).to_not be_valid
			end

			it "provides error message" do
				expect(location).to respond_to :errors
				expect(location.errors).to_not be_nil
				expect(location.errors).to respond_to :messages
				expect(location.errors.messages).to include /name/
			end

		end
	end

	describe "Relationship" do

		let(:location) { FactoryGirl.build(:loc, :with_category) }

		context "can walk through association" do
			
			it "can access categories information" do
				expect(location).to respond_to :categories
				expect(location.categories).to_not be_nil
				expect(location).to have_field :categories
			end

			it "can have more than one category" do
				expect(location.categories.count).to be > 1
				expect(location.categories.to_a).to be >1
			end

		end

		context "can build association" do
			
			it "can build new category" do
				expect(location.categories.build(title: "Farming")).to be true
			end

			it "can persist category" do
				expect(location.categories.build(title: "Farming").save).to be true
			end

		end

		context "has foreign key field" do
			
			it "can walk back association"

			it "can create Location from category"
			
		end
	end

end