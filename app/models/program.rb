class Program < ActiveRecord::Base
  
  belongs_to :unique_destination
  belongs_to :category_program
  has_one :program_photo
  belongs_to :area
  has_many :walking_areas
  has_many :areas, through: :walking_areas
  has_many :countries, through: :areas
  belongs_to :end_area , :class_name => 'Area', :foreign_key => 'end_area_id'

  scope :uniques, -> { where(category_program_id: CategoryProgram.unique.id)}
  scope :uniques_search_areas, ->(param) {uniques.joins(:areas).includes(:areas).where("areas.name LIKE ?", "%#{param}%")}
  scope :uniques_search_countries, ->(param) {uniques.joins(:countries).includes(:countries).where("countries.name LIKE ?", "%#{param}%")}

  scope :search_uniques, ->(param) {uniques_search_areas(param)+uniques_search_countries(param)}

  def self.json_for_autocomplete(param)
    countries = Country.filter_by_name(param).as_json.each{|c| c["type"]="Country"}
    areas = Area.filter_by_name(param).as_json.each{|c| c["type"]="Area"}
    countries+areas
  end 

  def category_name
    self.category_program.nil? ? "" : self.category_program.name
  end
end
