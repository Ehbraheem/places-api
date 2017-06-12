class Location < ActiveRecord::Base

	has_many :landmarks, inverse_of: :location, dependent: :destroy

	has_many :categories, through: :landmarks

	validates_presence_of :name, unique: true

	
end