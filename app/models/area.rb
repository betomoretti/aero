class Area < ActiveRecord::Base

	has_many :walking_areas
	belongs_to :country
	has_many :programs, through: :walking_areas
    scope :filter_by_name, -> (param) { joins(:programs).where("areas.name LIKE ?", "#{param}%").uniq}
	
end