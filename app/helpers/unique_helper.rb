module UniqueHelper

	def print_areas_names(program)
		return "" if program.areas.blank?
		output = ""
		program.areas.each_with_index do |area,i|
			unless i == program.areas.size - 1
				output  <<  area.name + ",    "
			else
				output  <<  area.name 
			end
		end
		output  <<	'<br/>'
		raw(output)
	end 
	
	def print_days_names(program)
		return "" if program.days_week_names.blank?
		return "Diarias" if program.days_week_names.count == 7
		output = ""
		program.days_week_names.each_with_index do |day,i|
			n = i+1
			output  << day + "    "
		end
		output  <<	'<br/>'
		raw(output)
	end

	def parse_price(number)
		number = number.to_s
		temp_result = number.split('.')
		part_integer = temp_result[0]
		part_decimal = temp_result[1]
		unless part_integer.nil?
		  cant = part_integer.length - 3
		  if cant>0
		    part_integer.insert(cant,".")
		  end
		end


		result = part_integer
		result = result+','+part_decimal.slice(0,2) unless part_decimal.nil?
		if result == '0' then result = '' end
		return result
	end

	def coin_code(symbol)
		codes = {'€'=>'EUR', '$' => 'PES', 'USD' => 'USD'}
		codes[symbol]
	end
end
