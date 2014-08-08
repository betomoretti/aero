class Program < ActiveRecord::Base
  belongs_to :unique_destination
  belongs_to :category_program
  scope :uniques, -> { where(category_program_id: CategoryProgram.unique.id)}

  def search_uniques(param)
  	# programs = self.uniques.joins(unique_destinations: :unique_zones).where('unique_destinations LIKE ? OR unique_zones LIKE ?', "%#{param}%", "%#{param}%")
  	return self.uniques
  end 
end
