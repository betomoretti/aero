#!/bin/env ruby
# encoding: utf-8

class FaresForCategory < ActiveRecord::Base
  has_many :fare_lines, :conditions => "confirm = #{true}", :include => [:season,:tax,:markup,:static_fares]
  belongs_to :category
#  belongs_to :policy_child
  belongs_to :hotel
	has_many :lock_fares
  before_destroy :destroy_fare_lines, :validates_empty
  delegate :policy_child,:country, :area, :destination, :to => :hotel
  accepts_nested_attributes_for :fare_lines, :allow_destroy => true
  # accepts_nested_attributes_for :category

  def before_save
    if self.policy_child_id.blank? then
      self.min_age_child = nil
      self.max_age_child = nil
    end
  end

  def validates_empty
    errors.add(:base, "No se puede borrar la categoria.") unless if_empty
    errors.blank? #return false, to not destroy the element, otherwise, it will
  end
  
  def self.new(*args)
    fareForCategory = super(*args)
    fareForCategory.build_category if fareForCategory.category.nil? 
    fareForCategory.number = 1 if fareForCategory.number.nil? 
    return fareForCategory
  end

  def destroy_fare_lines
    FareLine.destroy_all("fares_for_category_id = #{self.id}") 
  end
  
  def have_child_fare?
    return !(self.min_age_child.nil? and self.max_age_child.nil?)
  end
  
  def is_child_free?(child)
    unless self.min_age_child.blank? || self.max_age_child.blank?
      return child.is_less(self.min_age_child)
    end
    return false
  end
  
  def get_all_fare_lines(current = true)
    all_fare_lines = FareLine.find(:all, :conditions => [ "fares_for_category_id = ?", self.id])
    all_fare_lines = all_fare_lines.select { |fare_line| fare_line.is_current?  } unless !current
    return all_fare_lines
  end

  def get_current_fare_lines
    current_fare_lines = Array.new
    self.fare_lines.each do |fare_line|
      if fare_line.is_current? 
        current_fare_lines.push(fare_line)
      end unless (fare_line.start_date.blank? or fare_line.end_date.blank?)
    end
    return current_fare_lines
  end

  def get_current_fare_lines_visibility
    current_fare_lines = Array.new
    self.fare_lines.all_publics.each do |fare_line|
      if fare_line.is_current? 
        current_fare_lines.push(fare_line)
      end unless (fare_line.start_date.blank? or fare_line.end_date.blank?)
    end
    return current_fare_lines
  end

  #retorna las nuevas con id = nil para validar.
  def get_nil_fare_lines
    current_fare_lines = Array.new
    self.fare_lines.each do |fare_line|
      if fare_line.id.nil? or fare_line.season.start_date.nil? or fare_line.season.end_date.nil? 
        current_fare_lines.push(fare_line) 
      end 
    end
    return current_fare_lines
  end
  
  def get_all_fare_lines_ordered(current = true) #force en false devuelve las tarifas que ya no tienen vigencia tambien
    fare_lines = self.get_all_fare_lines(current)
    return fare_lines.sort {|x,y| x.start_date <=> y.start_date }
  end
  
  #las fare lines que no son current y que no son tan viejas 6 meses
  def get_not_old_fare_lines
    old_fare_lines = Array.new
    self.fare_lines.each do |fare_line|
      if !fare_line.is_current? and fare_line.end_date > Date.today - 12.months
        old_fare_lines.push(fare_line)
      end unless (fare_line.start_date.blank? or fare_line.end_date.blank?)
    end
    return old_fare_lines
  end

  def get_fare_lines_ordered(current = true) #force en false devuelve las tarifas que ya no tienen vigencia tambien
    return get_not_old_fare_lines.sort{|x,y| x.start_date <=> y.start_date } if !current
    return get_current_fare_lines.sort {|x,y| x.start_date <=> y.start_date }
  end

  def get_fare_lines_ordered_and_visibility(current = true) #force en false devuelve las tarifas que ya no tienen vigencia tambien
    return fare_lines.all_publics.sort{|x,y| x.start_date <=> y.start_date } if !current
    return get_current_fare_lines_visibility.sort {|x,y| x.start_date <=> y.start_date }
  end

  def get_fare_lines_ordered_and_nil(current = true)
    return get_fare_lines_ordered(current) if !current
    return ( get_nil_fare_lines + get_fare_lines_ordered(true) ).uniq
  end

  def first?
    return self.hotel.first_category?(self.number)
  end
  
  def last_number
    return FareLine.maximum('number',:conditions=>[ "fares_for_category_id = ?", self.id ])
  end
  
  def first_number
    return FareLine.maximum('number',:conditions=>[ "fares_for_category_id = ?", self.id ])
  end
    
  def elements_deleted
    result = ''
    max = FareLine.maximum('number',:conditions=>[ "fares_for_category_id = ?", self.id ])
    unless max.nil?
      numbers = self.fare_lines.collect { |item| item.number  }

      (0..max).each do
        |i|
        unless numbers.include?(i)
          if result.empty? then
            result = result+i.to_s
          else
            result = result+','+i.to_s
          end      
        end  
      end
      return result
    end
    
  end

  def is_equal?(other_fares_for_category)
    result = false
    if other_fares_for_category.category.is_equal?(self.category) then
      other_fares_for_category.fare_lines.each do |fare_line|
        result = fare_line.have_equal?(self.fare_lines)
        if result then break end
      end
    end
    return result
  end

  def is_equal_with_hash?(fares_for_category_hash)#Is the hash in de answer of import_csv
    result = false
    if fares_for_category_hash[:category].is_equal?(self.category) then
      self.fare_lines.each do |fare_line|
        result = fare_line.have_equal_with_hash?(fares_for_category_hash[:fare_lines])
        if result then break end
      end
    end
    return result
  end

  def max_number_fare_line
    max = 0
    fare_lines = self.get_all_fare_lines(false)
    unless fare_lines.empty?
      fare_lines.each do |fare|
        if fare.number > max
          max = fare.number
        end
      end
    else
      max = -1
    end
    
    return max
  end

	def has_lock_fares?
		return self.lock_fares.size > 0
	end

  def available_lock_fares
    return self.lock_fares.select { |lock_fare| lock_fare.has_available? }
  end

	def lock_fares_with_sold_rooms
		return self.lock_fares.select { |lock_fare| lock_fare.cant_room_solds > 0 }
	end

	def seasons
		seasons = Array.new
		self.get_fare_lines_ordered.each { |fare_line|  seasons.push(fare_line.season) }
		return seasons
	end
  
  def clean_parser
    if self.get_all_fare_lines.empty? then
      self.destroy
    end
  end
  
  def get_max_passengers
    if self.max_passengers.blank?
      return self.hotel.get_max_passengers
    else
      self.max_passengers
    end
  end
  
  def text_max_passengers_to_hotels
    if self.get_max_passengers < 4
      return "(Máximo #{self.get_max_passengers} pasajeros)"
    end
  end

  def if_empty
    true if lock_fares.empty?
  end

end
