require 'sinatra/base'
require "sinatra/activerecord"
require "sinatra/namespace"
require "mongoid"
require "sinatra/jbuilder"

require "byebug"

ENV['RACK_ENV'] = 'development'

# Eager Load all models files
current_dir = Dir.pwd
# ./lib/
Dir["#{current_dir}/lib/*.rb"].each {|file| require_relative file }

# ./models/
Dir["#{current_dir}/models/*.rb"].each {|file| require_relative file }

require "./config/environment" # db configurations


class PlacesApi < Sinatra::Base

	Dir["#{Dir.pwd}/helpers/*.rb"].each {|file| require_relative file }

	include RouteHelpers


	register Sinatra::Namespace
	# byebug

	 get '/' do
	 	{:welcome => "This is a test JSON response"}.to_json
	 end

	 namespace '/api/v1' do
	 	
	 	before do
	 		content_type 'application/json'
	 	end

	 	get '/' do
	 		jbuilder :index
	 	end

	 	get '/locations' do
	 		@location = Location.all

	 		jbuilder :index

	 	end
	 end

	 # Start the server if this file is executed directly
	 run! if app_file == $0

end