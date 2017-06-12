class Landmark < ActiveRecord::Base

	belongs_to :category

	belongs_to :location

	validates_presence_of :category_id, :location_id

	validates_associated :location, :category
	
end