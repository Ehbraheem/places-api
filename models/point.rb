require_relative File.join ".", "mongoid_helper"

class Point

	extend MongoidHelper

	attr_reader :lng, :lat

	def initialize(arr)
		return  if arr.nil?
		@lat, @lng = arr
	end

	def to_a
		[@lat, @lng]
	end

	def mongoize
		{type: self.class.name, coordinates: self.to_a}
	end

	def self.mongoize object
		self.mongoizer object, :coordinates
	end

	def self.demongoize object
		self.demongoizer object, :coordinates
	end

end