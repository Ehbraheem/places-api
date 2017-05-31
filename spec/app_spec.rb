require "spec_helper"
require "rack/test"
require_relative "../app"

RSpec.describe 'Places API' do

	include Rack::Test::Methods

	def app
		PlacesApi
	end

	it 'says hi' do
		get '/'

		expect(last_response).to be_ok
	end
end