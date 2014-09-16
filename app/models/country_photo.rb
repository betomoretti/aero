class CountryPhoto < ActiveRecord::Base
	belongs_to :country

	def photo_thumb
		elem = CountryPhoto.select("filename").where(parent_id: self.id.to_s, thumbnail: "thumbnail").first_or_initialize
		@string = "http://s3.amazonaws.com/aerolaplata-dev/country_photos/"<<self.id.to_s<<"/"<<elem.filename	  							
	end

	def photo_header
		elem = CountryPhoto.select("filename").where(parent_id: self.id.to_s, thumbnail: "header").first_or_initialize
		@string = "http://s3.amazonaws.com/aerolaplata-dev/country_photos/"<<self.id.to_s<<"/"<<elem.filename	  							
	end
end
