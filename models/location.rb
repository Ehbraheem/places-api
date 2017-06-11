class Location < ActiveRecord::Base

	has_many :categories, inverse_of: :location, dependent: :destroy

	validates_presence_of :name, unique: true

	
end