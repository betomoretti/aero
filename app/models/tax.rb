#!/bin/env ruby
# encoding: utf-8

class Tax < ActiveRecord::Base

  has_many :markups
  has_many :destinations, :foreign_key => "general_tax_id"
  has_many :services
  
end
