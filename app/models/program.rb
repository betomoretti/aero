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
  scope :output_groups, -> {where(output_group: true)}

  def self.json_for_autocomplete(param)
    countries = Country.filter_by_name_join_programs(param).as_json.each{|c| c["type"]="Country"}
    areas = Area.filter_by_name_join_programs(param).as_json.each{|c| c["type"]="Area"}
    countries+areas
  end 

  def category_name
    self.category_program.nil? ? "" : self.category_program.name
  end

  def self.days_week
     Hash["1" => "Lunes", "2" => "Martes", "3" => "Miércoles", "4" => "Jueves", "5" => "Viernes", "6" => "Sábado", "0" => "Domingo"]
  end

  def days_week_names
    return nil if days.blank?
    self.days.gsub(/\D/,' ').split.collect{|number| Program.days_week[number] }
  end
   
end
