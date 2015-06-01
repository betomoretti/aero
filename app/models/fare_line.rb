#!/bin/env ruby
# encoding: utf-8

class FareLine < ActiveRecord::Base
  belongs_to :fares_for_category
  belongs_to :season, :inverse_of => :fare_lines
  belongs_to :restriction
  belongs_to :promotion, :inverse_of => :fare_line
  belongs_to :tax
  belongs_to :markup
  belongs_to :regimen
  belongs_to :coin #El coin propio no el del pais.
  has_many :static_fares , :inverse_of => :fare_line
  before_destroy :destroy_static_fares, :destroy_regimen, :destroy_promotion
  delegate :policy_child,:lock_fares,:category,:hotel,:destination,:country,:area, :to=> :fares_for_category
  delegate :start_date,:end_date, :to=> :season
  delegate :regimen_type, :aditional_regimen, :to => :regimen

  accepts_nested_attributes_for :season
  accepts_nested_attributes_for :tax
  accepts_nested_attributes_for :markup
  accepts_nested_attributes_for :restriction
  accepts_nested_attributes_for :regimen
  accepts_nested_attributes_for :promotion,:allow_destroy => true, :reject_if => proc { |a| a[:name].blank? }
  accepts_nested_attributes_for :static_fares,:allow_destroy => true, :reject_if => proc { |a| a[:price].blank? }

  validates_numericality_of :chd1,:message => 'El valor del child es numerico.' ,:allow_blank => true
  validates_numericality_of :chd2,:message => 'El valor del child es numerico.', :allow_blank => true
  validates_numericality_of :child_fare,:message => 'El valor del child es numerico.', :allow_blank => true
  validates_numericality_of :cambio,:message => 'El valor del cambio es numerico.', :allow_blank => true, :greater_than => 0, :less_than => 18

  validate :expiration_date_cannot_be_in_the_past, :all_static_fares_blank

  named_scope :all_publics , :conditions => [ "visibility = ?",true ]

  def expiration_date_cannot_be_in_the_past
    errors.add(:expiration_date, "La fecha de expiracion es anterior al dia de hoy.") if
        !expiration_date.blank? and expiration_date < Date.today
  end

  def all_static_fares_blank
    errors.add(:cuartos, "Faltan precios de los cuartos.") if
    static_fares.detect{|static_fare| !static_fare.price.blank?}.nil?
  end

  def before_validation
    #Marco que van a ser eliminados los objetos blancos y omitir validacion.
    promotion_delete_if_blank
    markup_delete_if_blank
    tax_delete_if_blank
    static_fares_delete_if_blank
  end

  def static_fares_delete_if_blank
    self.static_fares = static_fares.map{
      |static_fare|
      if static_fare.price.blank? and !static_fare.id.blank?
        static_fare.mark_for_destruction
        static_fare
      else
        static_fare
      end
    }

    self.static_fares = static_fares.select{|static_fare| !static_fare.price.blank? or !static_fare.id.blank?  }
  end

  def promotion_delete_if_blank
    @promotion = Promotion.new if @promotion.nil?
    if @promotion.start_date.blank? and @promotion.end_date.blank? and @promotion.name.blank?
      if !@promotion.id.blank?
        @promotion.mark_for_destruction
      else
        @promotion = nil
      end
    end
  end

  def markup_delete_if_blank
    @markup = Markup.new if @markup.nil?
    #Si es blanco se elimina. No se tiene que validar.
    if @markup.if_value_nil?
      if !@markup.id.blank?
        @markup.mark_for_destruction
      else
        @markup = nil
      end
    end
  end

  def tax_delete_if_blank
    @tax = Tax.new if @tax.nil?
    #Si tax es blanco se elimina y se toma el defecto
    if @tax.value.nil?
      if !@tax.id.blank?
        @tax.mark_for_destruction
      else
        @tax = nil
      end
    end
  end


  def autosave_associated_records_for_season
    self.season_id = (Season.new_or_recover_if_exits(season.hotel_id ,season.start_date ,season.end_date )).id if !season.nil?
  end

  def autosave_associated_records_for_markup
    self.markup = Markup.new_or_recover_if_exits(markup.value.to_s,markup.tax.type) if !markup.nil?
  end

  def autosave_associated_records_for_tax
    self.tax = Tax.new_or_recover_if_exits(tax.value.to_s,tax.type) if !tax.nil?
  end

  def self.new(*args)
    fareLine = super(*args)
    fareLine.build_all
    return fareLine
  end

  def destroy_static_fares
    StaticFare.destroy_all("fare_line_id = #{self.id}")
    self.clean_tax
  end

	def clean_restriction
		self.update_attribute(:restriction_id, nil)
	end

  def destroy_regimen
    Regimen.destroy(self.regimen.id) unless self.regimen.nil?
  end

  def destroy_promotion
    Promotion.destroy(self.promotion.id) unless self.promotion.nil?
  end

	def child_fare_1
		return self.chd1
	end

	def child_fare_2
		return self.chd2
	end

	def single
		return self.static_fares.detect { |fare| fare.single }
	end

  def single_fare_id
		static_fare = self.single
    if self.single.nil?
      return static_fare
    else
      return static_fare.id
    end
  end

  def single_fare_price
    static_fare = self.single
    if static_fare.nil?
      return ''
    else
      return static_fare.price
    end
  end

  def single_fare_price_with_markup
    static_fare = self.single
    if static_fare.nil?
      return ''
    else
      return static_fare.get_price_with_markup
    end
  end

	def double
		return self.static_fares.detect { |fare| fare.double }
	end

  def double_fare_id
    static_fare = self.double
    if self.double.nil?
      return static_fare
    else
      return static_fare.id
    end
  end

  def double_fare_price
    static_fare = self.double
    if static_fare.nil?
      return ''
    else
      return static_fare.price
    end
  end

  def double_fare_price_with_markup
    static_fare = self.double
    if static_fare.nil?
      return ''
    else
      return static_fare.get_price_with_markup
    end
  end

	def triple
		return self.static_fares.detect { |fare| fare.triple }
	end

  def triple_fare_id
    static_fare = self.triple
    if static_fare.nil?
      return static_fare
    else
      return static_fare.id
    end
  end

  def triple_fare_price
    static_fare = self.triple
    if static_fare.nil?
      return ''
    else
      return static_fare.price
    end
  end

  def triple_fare_price_with_markup
    static_fare = self.triple
    if static_fare.nil?
      return ''
    else
      return static_fare.get_price_with_markup
    end
  end

	def quadruple
		return self.static_fares.detect { |fare| fare.quadruple }
	end

  def quadruple_fare_id
    static_fare = self.quadruple
    if static_fare.nil?
      return static_fare
    else
      return static_fare.id
    end
  end

  def quadruple_fare_price
    static_fare = self.quadruple
    if static_fare.nil?
      return ''
    else
      return static_fare.price
    end
  end

  def quadruple_fare_price_with_markup
    static_fare = self.quadruple
    if static_fare.nil?
      return ''
    else
      return static_fare.get_price_with_markup
    end
  end

	def apartment
		return self.static_fares.detect { |fare| fare.apartment }
	end

  def apartment_fare_id
    static_fare = self.apartment
    if static_fare.nil?
      return static_fare
    else
      return static_fare.id
    end
  end

  def apartment_fare_price
    static_fare = self.apartment
    if static_fare.nil?
      return ''
    else
      return static_fare.price
    end
  end

  def apartment_fare_price_with_markup
    static_fare = self.apartment
    if static_fare.nil?
      return ''
    else
      return static_fare.get_price_with_markup
    end
  end

  def get_regimen_name
    result = nil
    result = self.regimen.name unless self.regimen.nil?
    return result
  end

  def get_aditional_regimen_name
    result = nil
    result = self.regimen.get_aditional_regimen_name unless self.regimen.nil?
    return result
  end

  def get_regimen_value
    result = nil
    result = self.regimen.value unless self.regimen.nil?
    return result
  end

  def get_regimen_price
    result = 0
    unless self.regimen.nil?
      result = self.regimen.value unless self.regimen.value.blank?
    end
    return result
  end

  def search_fares(distribution,date_interval)#return static fares
    fares = Array.new
    unless distribution.cant_passengers > self.get_max_passengers
      if self.restriction.nil? then
        ok = true
      else
        ok = self.restriction.accepts?(date_interval)
      end
      if ok then
        today = Date.today
        ok = today < self.expiration_date unless self.expiration_date.nil?
      end
      if ok then
        self.static_fares.each do |static_fare|
          if static_fare.room == distribution.room then
            fares.push(static_fare) unless static_fare.price == 0
          end
        end
      end
    end
    return fares
  end

  def clean_tax
    unless self.tax.nil?
      self.update_attribute(:tax_id, nil)
    end
  end

  def clean_markup
    unless self.markup.nil?
      self.update_attribute(:markup_id, nil)
    end
  end
  def get_self_tax_value
    if self.tax.nil?
      return nil
    else
      return self.tax.value
    end
  end

  def get_self_tax_type
    if self.tax.nil?
      return nil
    else
      return self.tax.type
    end
  end

  def get_self_tax_print_type
    if self.tax.nil?
      return nil
    else
      return self.tax.print_type
    end
  end

  def get_self_markup_value
    if self.markup.nil?
      return nil
    else
      return self.markup.value
    end
  end

  def get_self_markup_type
    if self.markup.nil?
      return nil
    else
      return self.markup.type
    end
  end

  def get_description
    des = String.new
    des = self.description
    des = des + self.restriction.description unless self.restriction.nil?
    return des
  end

  def get_tax#works to the view in backend
    if self.tax.nil? then
      return self.hotel.get_tax
    else
      return self.tax.value
    end
  end

  def get_tax_integer(price)#works with the search
    if self.tax.nil? then
      if self.destination.general_tax.nil?
        return 0
      else
        return self.destination.general_tax.get_value(price)
      end
    else
      return self.tax.get_value(price)
    end
  end

  def get_markup(price = self.price)
    if self.markup.nil?
      if self.hotel.markup.nil?
        if self.destination.general_markup.nil?
          return 0
        else
          return self.destination.general_markup.get_value(price)
        end

      else
        return self.hotel.markup.get_value(price)
      end
    else
      return self.markup.get_value(price)
    end
  end

  def get_tax_type
    if self.tax.nil? then
      return ''
    else
      return self.tax.type
    end
  end

  def get_price_integer
    total = 0
    self.static_fares.each do |fare|
      total = total + fare.price
    end
    return total
  end

  def get_total_average_price
    total = 0
    self.static_fares.each do |fare|
      total = total + fare.price
    end
    return total/(self.static_fares.size)
  end

  def get_max_passengers
    self.fares_for_category.get_max_passengers
  end

  def is_equal?(other_fare_line)
    result = false
    if other_fare_line.season.is_equal?(self.season) then
      if other_fare_line.breakfast == self.breakfast && other_fare_line.map == self.map then
        if other_fare_line.single_fare_price == self.single_fare_price
          if other_fare_line.double_fare_price == self.double_fare_price
            if other_fare_line.triple_fare_price == self.triple_fare_price
              if other_fare_line.quadruple_fare_price == self.quadruple_fare_price
                result = true
              end
            end
          end
        end
      end
    end
    return result
  end

  def equal_price(price,other_price)
    return price.to_f == other_price.to_f
  end

  def is_equal_with_hash?(fare_line_hash)
    result = false
    if fare_line_hash[:season].is_equal?(self.season) then

      if equal_price(fare_line_hash[:static_fares][0].price,self.single_fare_price) then result = true end unless (fare_line_hash[:static_fares][0].nil?)
      if equal_price(fare_line_hash[:static_fares][1].price,self.double_fare_price) then result = true end unless (fare_line_hash[:static_fares][1].nil?)
      if equal_price(fare_line_hash[:static_fares][2].price,self.triple_fare_price) then result = true end unless (fare_line_hash[:static_fares][2].nil?)
      if equal_price(fare_line_hash[:static_fares][3].price,self.quadruple_fare_price) then result = true end unless (fare_line_hash[:static_fares][3].nil?)

    end
    return result
  end

  def have_equal?(fare_lines)
    result = false
    fare_lines.each do |fare_line|
      result = fare_line.is_equal?(self)
      if result
        break
      end
    end
    return result
  end

  def have_equal_with_hash?(fare_lines_hashes)
    result = false
    fare_lines_hashes.each do |fare_line_hash|
      result = self.is_equal_with_hash?(fare_line_hash)
      if result
        break
      end
    end
    return result
  end

  def get_print_aditional_regimen_with_markup
    result = String.new
    unless self.get_aditional_regimen_name.blank?
      result =  ((self.get_regimen_price + self.get_markup(self.get_regimen_price))).to_s
    end
    return result
  end

   def get_print_aditional_regimen_with_markup_and_cambio
    result = String.new
    unless self.get_aditional_regimen_name.blank?
      result =  ((self.get_regimen_price + self.get_markup(self.get_regimen_price)) * self.get_cambio).to_s
    end
    return result
  end

  #devuelve verdadero si la tarifa esta vigente con respecto a la fecha actual
  def is_current?
    ok = true
    today = Date.today
    ok = today < self.expiration_date unless self.expiration_date.nil?
    unless self.end_date.blank?
      if ok then ok = today <= self.end_date end
    end

    return ok
  end

  def promotion_description
    if self.promotion.nil? then
      return ' '
    else
      return self.promotion.description
    end
  end

	def apply_policy_child?
		if self.no_policy_child.blank? then
			return true
		else
			return !(self.no_policy_child)
		end
	end

	def get_general_child_price_with_markup
		unless self.child_fare.blank?
			if self.child_fare == 0 then
				return ''
			else
				return self.child_fare + self.get_markup(self.child_fare)
			end
		else
			return ''
		end
	end

  def get_status_for_date(date)

    if ((!self.created_at.nil?) and (self.created_at.to_date == date)) then
      return "Nueva"
    elsif ((!self.updated_at.nil?) and (self.updated_at.to_date == date))
      return "Modificada"
    else
      return ""
    end
  end

  def are_dates_inside_validity?(start_date,end_date)
    return self.season.some_date_are_inside?(start_date, end_date)
  end

  def get_corresponding_markup()
    if self.markup.nil?
      if self.hotel.markup.nil?
        if self.destination.general_markup.nil?
          return nil
        else
          return self.destination.general_markup
        end
      else
        return self.hotel.markup
      end
    else
      return self.markup
    end
  end

  def build_static_fare_for_all_rooms
    rooms = Room.all
    if !@static_fares.nil? then
      rooms.each do |room|
        if @static_fares.detect{|e| e.room_id == room.id}.nil?
          self.static_fares.build :room_id => room.id
        end
      end
    else
      rooms.each{|r| self.static_fares.build :room_id => r.id}
    end
  end

  def build_all
    build_static_fare_for_all_rooms
    build_regimen  if regimen.nil?
    build_promotion if promotion.nil?
    self.markup ||= Markup.new(:tax => Tax.new)
    self.tax ||= Tax.new()
    self.season ||= Season.new()
  end

  # => te da el valor del cambio actual
  def get_cambio
    #Si tengo cambio retorno el cambio
    return self.cambio unless self.cambio.blank?

    #Si no tengo cambio ni coin cargado retorno 1
    return 1 if self.cambio.blank? and self.coin_id.blank?

    #Si tengo coin y no cambio uso las de defecto las calculo en
    calculate_last_change

  end
  # => Solo usar con get_cambio.
  def calculate_last_change
    to_coin = hotel.country.coin.name
    from_coin = self.coin.name

    return Cambio.latest_dolar_peso if to_coin == "Dolar" and from_coin == "Peso"
    return Cambio.latest_dolar_euro if to_coin == "Dolar" and from_coin == "Euro"
    return Cambio.latest_peso_dolar if to_coin == "Peso"  and from_coin == "Dolar"
    return Cambio.latest_peso_euro  if to_coin == "Peso"  and from_coin == "Euro"
    return Cambio.latest_euro_peso  if to_coin == "Euro"  and from_coin == "Peso"
    return Cambio.latest_euro_dolar if to_coin == "Euro"  and from_coin == "Dolar"
  end

  def single_fare_price_with_markup_and_tax
    # Solo si es argentina se aplica el tax, que corresponde al valor del iva.
    tax_for_argentina(self.single_fare_price_with_markup)
  end

  def double_fare_price_with_markup_and_tax
     # Solo si es argentina se aplica el tax, que corresponde al valor del iva.
    tax_for_argentina(self.double_fare_price_with_markup)
  end

   def triple_fare_price_with_markup_and_tax
    # Solo si es argentina se aplica el tax, que corresponde al valor del iva.
    tax_for_argentina(self.triple_fare_price_with_markup)
  end

   def quadruple_fare_price_with_markup_and_tax
    # Solo si es argentina se aplica el tax, que corresponde al valor del iva.
    tax_for_argentina(self.quadruple_fare_price_with_markup)
  end

  def get_print_aditional_regimen_with_markup_and_cambio_and_tax
    # Solo si es argentina se aplica el tax, que corresponde al valor del iva.

    tax_for_argentina(self.get_print_aditional_regimen_with_markup_and_cambio)


  end


  def child_fare_1_with_markup_and_tax_and_cambio(type = "int")
    if self.chd1.nil?
      chd_fare =  type == "int" ?  0 : ""
    else
      #Aplico markup
      value = self.chd1 + self.get_markup(self.chd1)
      #Aplico tax
      value = tax_for_argentina(value)
      #Aplico Cambio
      chd_fare = (value * self.get_cambio).to_i
    end
    return self.policy_child.chd_fare_text(chd_fare)
  end

  def child_fare_2_with_markup_and_tax_and_cambio(type = "int")
    if self.get_max_passengers < 4
      return "-"
      else
      if self.chd2.nil?
        chd_fare = type == "int" ?  0 : ""
      else
        #Aplico markup
        value = self.chd2 + self.get_markup(self.chd2)
        #Aplico tax
        value = tax_for_argentina(value)
        #Aplico Cambio
        chd_fare = (value * self.get_cambio).to_i
      end
      return self.policy_child.chd_fare_text(chd_fare)
    end
  end

  # te retorna PRECIO + TAX ,se llama markup al valor del tax
  def tax_for_argentina(price)
    if self.country.id == 2
      sum = self.get_tax_integer(price.to_f).to_f + price.to_f
      return "" if sum == 0
      sum
    else
      return price
    end
  end

  def pesifico?
    return "" unless self.country.id == 2
    return "" if coin.blank?
    return "Esta reserva contiene tarifas en USD pesificadas al tipo de cambio del día que serán ajustadas según cambio del día de pago."  if self.coin.name != "Peso"
    ""
  end
end
