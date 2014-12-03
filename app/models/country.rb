class Country < ActiveRecord::Base

	has_many :areas
	has_many :programs, through: :areas
	has_many :services, through: :areas
	belongs_to :coin
    has_one :country_photo
   
    scope :unique_countries, -> { joins(:programs).where("programs.expiration_date = ?", Date.today) }
    scope :filter_by_name_join_programs, -> (param) { joins(:programs).where("countries.name LIKE ? AND programs.expiration_date > ?", "#{param}%", Date.today).uniq}
    scope :filter_by_name_join_services, -> (param) { joins(:services).where("countries.name LIKE ?", "#{param}%").order("category ASC").uniq}

    def self.uniques_programs_by_country_name(name)
		Country.find_by(name: name).programs.where("programs.expiration_date > ?", Date.today).uniques.uniq.sort_by{|u| u[:nights]}
	end

	def self.uniques_services_by_country_name(name)
		Country.find_by(name: name).services.uniq
	end
end
