class Service < ActiveRecord::Base
	
	belongs_to :destination
	belongs_to :tax
  	belongs_to :markup
	delegate :area, :to=>:destination
	delegate :country, :to=>:destination

	def self.json_for_autocomplete(param)
		countries = Country.filter_by_name_join_services(param).as_json.each{|c| c["type"]="Country"}
		areas = Area.filter_by_name_join_services(param).as_json.each{|c| c["type"]="Area"}
		countries+areas
	end

	def get_markup(price)
		if self.markup.nil?
			if self.destination.general_markup.nil?
				return 0
			else
				return self.destination.general_markup.get_value(price)
			end
		else
			return self.markup.get_value(price)
		end
	end

	def get_price_with_markup
		return self.price + self.get_markup(self.price)
	end

	def get_tax_integer
		if self.tax.nil? then
			if self.destination.general_tax.nil?
				return 0
			else
				return self.destination.general_tax.get_value(self.get_price_with_markup)
			end
		else
			return self.tax.get_value(self.get_price_with_markup)
		end	
	end

	def get_child_price_with_markup
	    if self.child_price.blank?  then
	    	return self.price + self.get_markup(self.price)
	    else
	    	return self.child_price + self.get_markup(self.child_price)
	    end
	end

	def get_tax_child_integer#works with the search
		if self.tax.nil? then
			if self.destination.general_tax.nil?
				return 0
			else
		 		return self.destination.general_tax.get_value(self.get_child_price_with_markup)
			end
		else
			return self.tax.get_value(self.get_child_price_with_markup)
		end
	end
end