#!/bin/env ruby
# encoding: utf-8

class ProgramPhoto < ActiveRecord::Base
  	belongs_to :program

	def photo
		@photo = "http://s3.amazonaws.com/aerolaplata-dev/program_photos/"<<self.id.to_s<<"/"<<self.filename	  							
	end  						
end