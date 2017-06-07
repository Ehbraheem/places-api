require "spec_helper"

RSpec.describe Location, type: :model, orm: :active_record do

	include_context "db_cleanup_each"

	describe Location do
		
		context "build valid Location" do

			it_should_behave_like "build valid object", [:location, ["name", "categories"]]

		end

		context "build invalid Location" do

			it_should_behave_like "build invalid object", [:location, ["name", "categories"]]

		end
	end

	describe "Relationship" do

		it_should_behave_like "Associations", [:location, "category"]

	end

end