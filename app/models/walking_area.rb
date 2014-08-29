class WalkingArea < ActiveRecord::Base
	belongs_to :area
	belongs_to :program
end
