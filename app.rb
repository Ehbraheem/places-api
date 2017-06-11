require 'sinatra/base'
require "sinatra/activerecord"
require "mongoid"
# require "byebug"

# Eager Load all models files
current_dir = Dir.pwd
# ./lib/
Dir["#{current_dir}/lib/*.rb"].each {|file| require_relative file }

# ./models/
Dir["#{current_dir}/models/*.rb"].each {|file| require_relative file }





class PlacesApi < Sinatra::Base

	# byebug
	require "./config/environment" # db configurations

	 get '/' do
	 	{:welcome => "This is a test JSON response"}.to_json
	 end

end