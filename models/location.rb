class Location < ActiveRecord::Base

	has_many :landmarks, inverse_of: :location, dependent: :destroy

	has_many :categories, through: :landmarks

	validates_presence_of :name
	validates_uniqueness_of :name

	# scope :with_name, -> (name) { find_by(:name => name) }

	# scope :for_category, -> { with_name.categories }

	before_save :downcase_name

	def self.with_name name
		find_by(:name => name)
	end

	def downcase_name
		self.name = name.gsub(/\s/, "+").downcase
	end
end