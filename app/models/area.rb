class Area < ActiveRecord::Base

	has_many :walking_areas
	belongs_to :country

end