#!/bin/env ruby
# encoding: utf-8

class PercentageTax < Tax
   
  def get_value(price)
    if price.blank? then
      return 0
    else
      return price*(self.value/100.to_f)
    end
  end

  def get_markup_value(price)#recive percentage value ejem 20%
    if price.blank? then
      result = 0
    else
      result = price/((100-self.value)/100)*(self.value/100)
    end
    return result
  end

end
