class WalkingArea < ActiveRecord::Base
	belongs_to :area
	# belongs_to :program, -> { where category_program_id: CategoryProgram.unique.id, show_in_unique: true}
	belongs_to :program, -> { where "category_program_id = ? AND show_in_unique = 1", CategoryProgram.unique.id}
end
