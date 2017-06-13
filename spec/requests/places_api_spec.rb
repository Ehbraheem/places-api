require File.expand_path "../../spec_helper.rb", __FILE__

RSpec.describe "Places API", type: :requests do
	
	include_context "db_cleanup_each" 

	describe "Root page" do
		
		describe "Empty database" do

			context "Return type" do
				
				it "returns HTTP status OK"
			
				it "returns empty JSON document" 

			end

			context "Valid response" do
				
				it "HTTP status is 2xx"

				it "returns valid document from DB"

				it "returns all available document"

			end

		end

		describe "Non-empty database" do

			context "Return type" do
				
				it "returns HTTP status OK"

				it "returns all documents"

			end

			context "Valid response" do
				
				it "HTTP status is 2xx"

				it "returns valid document from DB"

				it "returns all available document"

			end

		end

		context ""
	end
end