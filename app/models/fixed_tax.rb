#!/bin/env ruby
# encoding: utf-8

class FixedTax < Tax
  
  def get_value(price)
    return self.value
  end

  def get_markup_value(price)
    return price
  end
end
