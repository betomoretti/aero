class Country < ActiveRecord::Base

	has_many :areas
	has_many :programs, through: :areas
	has_many :services, through: :areas
	belongs_to :coin
    has_one :country_photo
   
    scope :unique_countries, -> { joins(:programs) }
    scope :filter_by_name_join_programs, -> (param) { joins(:programs).where("countries.name LIKE ?", "#{param}%").uniq}
    scope :filter_by_name_join_services, -> (param) { joins(:services).where("countries.name LIKE ?", "#{param}%").uniq}

    def self.uniques_programs_by_country_name(name)
		Country.find_by(name: name).programs.uniq.sort_by{|u| u[:nights]}
	end

	def self.uniques_services_by_country_name(name)
		Country.find_by(name: name).services.uniq
	end
end
