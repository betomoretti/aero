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
end
