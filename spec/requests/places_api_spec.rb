require File.expand_path "../../spec_helper.rb", __FILE__

include ApiHelper

RSpec.describe "Places API", type: :request do
	
	include_context "db_cleanup_each" 

	describe "Root page" do

		before(:each) do
			jget base_path
		end 
		
		describe "Empty database" do

			it_should_behave_like "Check response"

			it_should_behave_like "Return type"

			it_should_behave_like "Valid response"

		end

		describe "Non-empty database" do

			it_should_behave_like "Check response"

			it_should_behave_like "Return type"

			it_should_behave_like "Valid response"

		end

	end

	describe "Locations page" do

		before(:each) do
			jget locations_path
		end   
		
		describe "Empty database" do

			it_should_behave_like "Check response"

			it_should_behave_like "Return type"

			it_should_behave_like "Valid response"

		end

		describe "Non-empty database" do

			it_should_behave_like "Check response"

			it_should_behave_like "Return type"

			it_should_behave_like "Valid response"

			it_should_behave_like "Return all data currently availabe", :location 

			it_should_behave_like "return accurate number of records", :location

			it_should_behave_like "verify JSON docuemnt returned", [:location, :name]

			it_should_behave_like "verify data", :location

		end

	end

	describe "Category page" do

		before(:each) do
			jget categories_path
		end 
		
		describe "Empty database" do

			it_should_behave_like "Return type"

			it_should_behave_like "Valid response"

		end

		describe "Non-empty database" do

			it_should_behave_like "Return type"

			it_should_behave_like "Valid response"

			it_should_behave_like "Return all data currently availabe", :category 

			it_should_behave_like "return accurate number of records", :category

			it_should_behave_like "verify JSON docuemnt returned", [:category, :title]

			it_should_behave_like "verify data", :category

		end

	end

	describe "Places page" do

		before(:each) do
			jget places_path
			it_should_behave_like
		end 
		
		describe "Empty database" do

			it_should_behave_like "Check response"

			it_should_behave_like "Return type"

			it_should_behave_like "Valid response"

		end

		describe "Non-empty database" do

			it_should_behave_like "Check response"

			it_should_behave_like "Return type"

			it_should_behave_like "Valid response"

			it_should_behave_like "Return all data currently availabe", :place 

			it_should_behave_like "return accurate number of records", :place

			it_should_behave_like "verify JSON docuemnt returned", [:place, :name]

			it_should_behave_like "verify data", :place

		end

	end

	describe "Place page" do

		before(:each) { jget places_path(23)  }
		
		describe "Empty database" do

			it_should_behave_like "Check response"

			it_should_behave_like "Return type"

			it_should_behave_like "Valid response"

		end

		describe "Non-empty database" do

			it_should_behave_like "Check response"

			it_should_behave_like "Return type"

			it_should_behave_like "Valid response"

			it_should_behave_like "Return all data currently availabe", :place 

			it_should_behave_like "return accurate number of records", :place

			it_should_behave_like "verify JSON docuemnt returned", [:place, :name]

			it_should_behave_like "verify data", :place

		end

	end
end