class Service < ActiveRecord::Base
	
	belongs_to :destination
	delegate :area, :to=>:destination
	delegate :country, :to=>:destination

	def self.json_for_autocomplete(param)
		countries = Country.filter_by_name_join_services(param).as_json.each{|c| c["type"]="Country"}
		areas = Area.filter_by_name_join_services(param).as_json.each{|c| c["type"]="Area"}
		countries+areas
	end
end