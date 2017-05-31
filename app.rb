require 'sinatra/base'
require "sinatra/activerecord"
require "mongoid"
# require "byebug"




class PlacesApi < Sinatra::Base

	# byebug
	require "./config/environment" # db configurations

	 get '/' do
	 	{:welcome => "This is a test JSON response"}.to_json
	 end

end