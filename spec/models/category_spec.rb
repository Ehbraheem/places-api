require File.expand_path "../../spec_helper.rb", __FILE__

RSpec.describe Category, type: :model, orm: :active_record do

	include_context "db_cleanup_each"

	describe Category do
		
		context "build valid Category" do

			it_should_behave_like "build valid object", [:category, ["title", "places"]]

		end

		context "build invalid Category" do

			it_should_behave_like "build invalid object", [:category, ["title", "places"]]

		end
	end

	describe "ActiveRecord to Mongoid Relationship" do

		it_should_behave_like "Associations", [:category, "place"]

		it_should_behave_like "Verify Associations", [:category, "place"]
		
	end

	describe "ActiveRecord Relationship" do
		
		it_should_behave_like "Associations", [:category, "location"]

		it_should_behave_like "Associations", [:category, "landmark"]

		it_should_behave_like "Verify Associations", [:category, "landmark"]

	end

	describe "Has many Location through Landmark" do
		
		it_should_behave_like "Ownership", [:landmark, "category", "location"]

	end

end