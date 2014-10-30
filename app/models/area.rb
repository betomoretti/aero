class Area < ActiveRecord::Base

	has_many :walking_areas
	belongs_to :country
	has_many :programs, through: :walking_areas
	has_many :destinations
	has_many :services, through: :destinations

    scope :filter_by_name_join_programs, -> (param) { joins(:programs).where("areas.name LIKE ?", "#{param}%").uniq}
    scope :filter_by_name_join_services, -> (param) { joins(:services).where("areas.name LIKE ?", "#{param}%").uniq}
	
end