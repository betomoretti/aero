#!/bin/env ruby
# encoding: utf-8

class CategoryProgram < ActiveRecord::Base
  has_many :programs
  has_one :program_category_photo

   def self.unique
    # category = self.find(:first, :conditions => [ "category_programs.name = ?", "Unique"])
    # category ||= self.new(:name => "Unique")

    category = self.where(:name => 'Unique').first_or_create
    return category
  end
end
