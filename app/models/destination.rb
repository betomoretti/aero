class Destination < ActiveRecord::Base
	belongs_to :area
	has_many :services, -> { where unique: 1}

    scope :filter_by_name_join_services, -> (param) { joins(:services).where("destinations.name LIKE ?", "#{param}%").uniq}
end