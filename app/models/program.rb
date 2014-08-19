class Program < ActiveRecord::Base
  belongs_to :unique_destination
  belongs_to :category_program
  scope :uniques, -> { where(category_program_id: CategoryProgram.unique.id)}
  scope :search_uniques, ->(param) {uniques.joins(unique_destination: :unique_zone).where('unique_destinations.name LIKE ? OR unique_zones.name LIKE ?', "%#{param}%", "%#{param}%")}

  def temp_photo
  	"http://s3.amazonaws.com/aerolaplata/program_category_photos/8/SOL_Y_PLAYA.png"
  end
end
