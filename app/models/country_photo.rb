class CountryPhoto < ActiveRecord::Base
	belongs_to :country

	def photo
		@string = "http://s3.amazonaws.com/aerolaplata/country_photos/"<<self.id.to_s<<"/"<<self.filename	  							
	end

	def photo_thumb
		elem = CountryPhoto.select("filename").where(parent_id: self.id.to_s, thumbnail: "thumbnail").first_or_initialize
		@string = "http://s3.amazonaws.com/aerolaplata/country_photos/"<<self.id.to_s<<"/"<<elem.filename	  							
	end
end
