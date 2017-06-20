require "mongoid"
require_relative File.absolute_path "./models/availability.rb"
require_relative File.absolute_path "./models/point.rb"

class Place

	include Mongoid::Document
	include Mongoid::Attributes::Dynamic
	include Mongoid::ActiveRecordBridge
	Mongoid::QueryCache.enabled = true

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

	index( { location: 1}, { background: true})


	validates_presence_of :location, :icon, :reference, :formatted_address, :name, :place_id, :geometry #:opening_hours, 
	validates_uniqueness_of :name, :place_id, :geometry

	# scope :for_category, ->(category_id, location_id) { where(:category_id => category_id, :location=> location_id)}

	def self.for_category category, location
		return [] if !!(category && location)
		where(:category_id => category.try(:id), :location=> location.try(:id))
	end

	before_save :set_geometry
	before_upsert :set_geometry

	def set_geometry 
		self.geometry = self.geometry.keys.inject({}) do |hash, key|
			if 'location' != key
				hash[key] = self.geometry[key].keys.inject({}) do |emp, e|
								emp[e] = Point.new self.geometry[key][e].values
								emp
							end
			else
				hash[key] = Point.new self.geometry[key].values
			end
			hash
		end
	end
	

end