require 'sinatra/base'
require "sinatra/activerecord"
require "mongoid"
require "byebug"




class PlacesApi < Sinatra::Base

	# byebug
	require "./config/environment" # db configurations

	 get '/' do
	 	"Hello World!"
	 end

end