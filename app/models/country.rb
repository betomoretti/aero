class Country < ActiveRecord::Base

	has_many :areas
	has_many :programs, through: :areas
    has_one :country_photo
   
    scope :unique_countries, -> { joins(:programs) }
    scope :filter_by_name, -> (param) { joins(:programs).where("countries.name LIKE ?", "#{param}%").uniq}
end