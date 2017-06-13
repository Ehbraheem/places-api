require File.expand_path "../../spec_helper.rb", __FILE__


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

	describe "Cannot persist when associations are invalid" do

		it_should_behave_like "Associations validations", [:landmark, "location", "category", "name"]

		it_should_behave_like "Associations validations", [:landmark, "category", "location", "title"]
	end


	describe "Act as proxy" do

		it_should_behave_like "Ownership", [:landmark, "location", "category"]

		it_should_behave_like "Ownership", [:landmark, "category", "location"]

	end

	describe "Act as bridge" do

		it_should_behave_like "Connect two different tables", [:landmark, "location", "category"]

		it_should_behave_like "Connect two different tables", [:landmark, "category", "location"]

	end

	describe "Relationship with parent records" do
		
		it_should_behave_like "many-to-one Association", [:landmark, :location]

		it_should_behave_like "many-to-one Association", [:landmark, :category]
		
	end
	
end