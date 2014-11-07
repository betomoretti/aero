class Destination < ActiveRecord::Base
	belongs_to :area
	delegate :country,:to => :area
	has_many :services, -> { where unique: 1}
	belongs_to :general_markup, :class_name => "Markup", :foreign_key => "general_markup_id"
	belongs_to :general_tax, :class_name => "Tax", :foreign_key => "general_tax_id"

    scope :filter_by_name_join_services, -> (param) { joins(:services).where("destinations.name LIKE ?", "#{param}%").uniq}
end