class Area < ActiveRecord::Base

	has_many :walking_areas
	belongs_to :country
	has_many :programs, through: :walking_areas
	has_many :destinations
	has_many :services, through: :destinations

    scope :filter_by_name_join_programs, -> (param) { joins(:programs).where("areas.name LIKE ? AND programs.expiration_date > ?", "#{param}%", Date.today).uniq}
    scope :filter_by_name_join_services, -> (param) { joins(:services).where("areas.name LIKE ?", "#{param}%").order("category ASC").uniq}
	
	def self.unique_programs_by_area_name(name)
		Area.find_by(name: name).programs.where("programs.expiration_date > ?", Date.today).uniq.sort_by{|u| u[:nights]}
	end

	def self.unique_output_groups_by_area_name(name)
		Area.find_by(name: name).programs.where("programs.expiration_date > ? and programs.output_group = 1", Date.today).uniq.sort_by{|u| u[:nights]}
	end

	def self.unique_services_by_area_name(name)
		Area.find_by(name: name).services.uniq
	end
end