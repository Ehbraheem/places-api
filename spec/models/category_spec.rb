require "spec_helper"

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

	describe "Relationship" do

		it_should_behave_like "Associations", [:category, "place"]
		
	end

end