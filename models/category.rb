class Category < ActiveRecord::Base

	has_many :landmaks, inverse_of: :category

	has_many :locations, through: :landmaks

	has_many_documents :places #, inverse_of: :category

	validates_presence_of :title, unique: true

end