class Category < ActiveRecord::Base

	belongs_to :location

	has_many_documents :places #, inverse_of: :category

	validates_presence_of :title, :location_id, unique: true

	validates_associated :location

end