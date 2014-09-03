class WalkingArea < ActiveRecord::Base
	belongs_to :area
	belongs_to :program, -> { where category_program_id: CategoryProgram.unique.id}
end
