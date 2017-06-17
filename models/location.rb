class Location < ActiveRecord::Base

	has_many :landmarks, inverse_of: :location, dependent: :destroy

	has_many :categories, through: :landmarks

	validates_presence_of :name, unique: true

	scope :with_name, -> (name) { where(:name => name).first }

	# scope :for_category, -> { with_name.categories }

	before_save :downcase_name

	def downcase_name
		self.name = name.gsub(/\s/, "+").downcase
	end
end