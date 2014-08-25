class Program < ActiveRecord::Base
  belongs_to :unique_destination
  belongs_to :category_program
  has_one :program_photo
  scope :uniques, -> { where(category_program_id: CategoryProgram.unique.id)}
  scope :search_uniques, ->(param) {uniques.joins(unique_destination: :unique_zone).where('unique_destinations.name LIKE ? OR unique_zones.name LIKE ?', "%#{param}%", "%#{param}%")}

end
