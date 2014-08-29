class Program < ActiveRecord::Base
  
  belongs_to :unique_destination
  belongs_to :category_program
  has_one :program_photo
  has_many :walking_areas
  has_many :areas, :through => :walking_areas
  has_many :countries, :through => :areas
  scope :uniques, -> { where(category_program_id: CategoryProgram.unique.id)}
  scope :uniques_with_areas, -> {uniques.includes(:areas)}
  scope :uniques_with_countries, -> {uniques_with_areas.includes(:countries)}

  scope :uniques_search_areas, ->(param) {uniques.joins(:areas).where("areas.name LIKE ?", "%#{param}%")}
  scope :uniques_search_countries, ->(param) {uniques.joins(:countries).where("countries.name LIKE ?", "%#{param}%")}
  scope :search_uniques, ->(param) {uniques_search_areas(param)+uniques_search_countries(param)}

  scope :uniques_with_areas_and_countries, -> {uniques.includes(areas: :country)}
  scope :uniques_with_areas_and_countries_joins, -> {uniques.joins(areas: :country)}

  def self.json_for_autocomplete
  	uniques = self.uniques_with_areas_and_countries
  	result = []
  	uniques.each do |unique| 
  		unique.areas.each do |area| 
	  		result.push(area.name) 
	  		result.push(area.country.name)
  		end
  	end
  	result.uniq.sort
  end 
end
