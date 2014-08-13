#!/bin/env ruby
# encoding: utf-8
class CategoryProgram < ActiveRecord::Base
  has_many :programs
  has_one :program_category_photo

   def self.unique
    category = self.where(:name => 'Unique').first_or_create
  end
end
