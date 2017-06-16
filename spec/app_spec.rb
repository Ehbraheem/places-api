require File.expand_path "../spec_helper.rb", __FILE__

RSpec.describe 'Places API' do

	include Rack::Test::Methods

	def app
		PlacesApi
	end

	before(:each) { get '/'}

	

	it "has http status OK" do
		expect(last_response).to be_ok
	end

	it "returns correct documents" do
		payload = parsed_body

		expect(payload).to have_key "welcome"
		expect(payload["welcome"]).to_not be_nil
		expect(payload["welcome"]).to eq "This is a test JSON response"
	end
end