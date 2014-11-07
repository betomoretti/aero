#!/bin/env ruby
# encoding: utf-8

class Markup < ActiveRecord::Base
  belongs_to :tax
  delegate :value, :to => :tax
  delegate :type, :to => :tax
  has_many :services


 
  def get_value(price)
    if self.tax.nil? then
      return 0
    else
      return self.tax.get_markup_value(price)
    end
  end
  

  def value
    if self.tax.nil? then
      return 0
    else
      return self.tax.value
    end
  end


end
