class Category < ActiveRecord::Base

	has_many :landmarks, inverse_of: :category

	has_many :locations, through: :landmarks

	has_many_documents :places #, inverse_of: :category

	validates_presence_of :title, unique: true

end