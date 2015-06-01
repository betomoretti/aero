#!/bin/env ruby
# encoding: utf-8

class Category < ActiveRecord::Base
  
  validates_presence_of :name,:message => 'El nombre de la categoria es obligatorio'
  validates_uniqueness_of :name, :message => "Ya existe una categoria de hotel con ese nombre."
  has_many :fares_for_categories


  def name_safe
    return name.html_safe
  end

  def if_empty
    true if fares_for_categories.blank?
  end

  def self.new_or_recover_if_exits(name)
    category_find = self.find :first, :conditions => [ "name = ?", name ]
    if category_find.nil? then
       category = self.new(:name=>name)
       category.save
    else
       category = category_find
    end
    return category
  end

  
  def is_equal?(other_category)
    return other_category.name == self.name
  end
  
end
