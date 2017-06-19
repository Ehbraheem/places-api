require 'sinatra/base'
require "sinatra/activerecord"
require "sinatra/namespace"
require "mongoid"
require "sinatra/jbuilder"
require 'HTTParty'

# require "byebug"

# ENV['RACK_ENV'] = 'development'
# 
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

	 	get "/locations/:name" do |name|
	 		@location = Location.with_name name

	 		jbuilder :location

	 	end

	 	get "/locations/:location/categories" do |name|
	 		@categories = Location.with_name(name).categories

	 		jbuilder :categories
	 	end

	 	get "/locations/:location/categories/:title" do |name, title|
	 		@category = Location.with_name(name).categories.with_title(title)

	 		jbuilder :category
	 	end

	 	get "/locations/:location/categories/:title/places" do |name, title|
	 		@category ||= Category.with_title(title)
	 		@location ||= Location.with_name(name)
	 		@places = Place.for_category(@category.id, @location.id)

	 		jbuilder :places
	 	end

	 	get "/search" do 
	 		
	 		query = params.try(:[], "query") || params.try(:[], "q")
	 		match_data = query.match /\A(.+?)\sin\s(.+?)\z/i
	 		redirect "/api/v1/" if match_data[0].empty?
	 		location = match_data[2]
	 		category = match_data[1] 
	 		ApiDelegator::Delegate.save_data(match_data.to_a)
			 @location = Location.with_name(location)
			 @category = Category.with_title(category)
			 @places = Place.for_category(@category.id, @location.id)

	 		jbuilder :places
	 	end


	 end

	 # Start the server if this file is executed directly
	 run! if app_file == $0

end