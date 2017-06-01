require_relative File.join ".", "mongoid_helper"

class Availability

	extend MongoidHelper

	attr_reader :open_now, :weekdays_text

	def initialize(hash)
		return if hash.nil? 
		@open_now, @weekdays_text = hash.values
	end

	def mongoize
		{type: self.class.name, opening_hours: {open_now: @open_now, weekdays_text: @weekdays_text}}
	end

	def self.mongoize object
		self.mongoizer object, :opening_hours
	end

	def self.demongoize object
		self.demongoizer object, :opening_hours
	end

end