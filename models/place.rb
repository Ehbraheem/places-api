require "mongoid"
# require_relative File.absolute_path "./models/availability.rb"
require_relative File.absolute_path "./models/point.rb"

class Place

	include Mongoid::Document
	include Mongoid::ActiveRecordBridge

	belongs_to_record :category


	field :_id,  type: String, default: -> { id }
	field :id, type: String
	field :geometry, type: Hash, default: Point.new(nil).mongoize
	field :formatted_address, type: String
	field :icon, type: String
	field :name, type: String
	field :opening_hours, type: Availability
	field :place_id, type: String
	field :reference, type: String
	field :types, type: Array, default: []
	field :rating, type: Float, default: 0.0
	field :location, type: Array, default: []


	validates_presence_of :location, :icon, :opening_hours, :reference, :formatted_address, :name, :place_id, :geometry
	validates_uniqueness_of :name, :place_id, :geometry

	scope :for_category, ->(category_id, location_id) { where(:category_id => category_id, :location=> location_id)}
	

end