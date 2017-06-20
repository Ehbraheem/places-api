class Category < ActiveRecord::Base

	has_many :landmarks, inverse_of: :category, dependent: :destroy

	has_many :locations, through: :landmarks

	has_many_documents :places #, inverse_of: :category

	validates_presence_of :title, unique: true
	validates_uniqueness_of :title

	# scope :with_title, -> (title) { find_by(:title => title) }

	before_save :singular_title

	def self.with_title title
		title = title.gsub(/\s/, "+").downcase.singularize
		find_by(:title => title)
	end

	def singular_title
		self.title = title.singularize.downcase
	end

end