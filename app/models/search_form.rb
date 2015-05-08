 class SearchForm
	include ActiveModel::Model
	attr_accessor :word,:option_select, :id_search, :type_search

# bùsqueda de circuitos no solo a traves de walking areas sino tmb del area que tiene asignado el program. Deberìa refactorizarse

	def search_circuits
		return [] if word.blank?
		if id_search.blank? # Si no se selecciona el predictivo en la bùsqueda
			self.search_circuits_if_not_predictive
		else # Si se selecciona el predictivo en la bùsqueda
			self.search_circuits_if_predictive_selected
		end      
			if @programs_by_walking_area #si està definido el idArea
				programas = (@programs_by_walking_area + @programs_by_idArea).uniq  # Independientemente de cómo fue la búsqueda, estas son las variables que se usan y que se retornan.
				programas.sort! { |program1,program2| program1.nights <=> program2.nights }
				return programas
			end  
		[]
	end



	def search_circuits_if_not_predictive
			if Area.exists?(name: word) # Paìses y ciudades con el mismo nombre?
				@programs_by_walking_area = Area.unique_programs_by_area_name(word) # se buscan los programas a traves de walking areas por su nombre
				idArea = (Area.find_by name: word).id # se obtiene el id del area escrita en el search input
				@programs_by_idArea = Program.uniques.where("area_id = ? and expiration_date > ?",idArea,Date.today) #Se buscan los programas que tienen como area_id al idArea
			end
			if Country.exists?(name: word)    # Paìses y ciudades con el mismo nombre?
				@programs_by_walking_area = Country.unique_programs_by_country_name(word) #se buscan los paises a traves de walking areas por su nombre
				pais = (Country.find_by name: word) # se busca el paìs por su nombre
				areas = pais.areas.pluck(:id) # Se traen todas las areas posibles para ese paìs
				@programs_by_idArea = Program.uniques.where(:area_id => areas).where("expiration_date > ?", Date.today) #Se buscan los programas que tienen como area_id dentro de los id de areas que tiene el país
			end
	end    

	def search_circuits_if_predictive_selected
				type = type_search.camelize.constantize #convierte el type_search en Model
			@programs_by_walking_area = type.find(id_search).programs.where("programs.expiration_date > ?", Date.today)
			if type_search == "Country"
				pais = Country.find(id_search) #Se debe buscar el país correspondiente al paràmetro
				areas = pais.areas.pluck(:id)  # Se traen todas las areas posibles para ese paìs
				@programs_by_idArea = Program.uniques.where(:area_id => areas).where("expiration_date > ?", Date.today) #Se buscan los programas cuyo id_area es uno de las Areas del país
			end  
			if type_search == 'Area'
				@programs_by_idArea = Program.uniques.where("area_id = ? and expiration_date > ?",id_search,Date.today) # Se buscan los programas que tengan id_area = id_search
			end
	end              


	def search_hotels
		return [] if word.blank?
		if id_search.blank? # Si no se selecciona el predictivo en la bùsqueda
			self.search_hotels_if_not_predictive
		else # Si se selecciona el predictivo en la bùsqueda
			self.search_hotels_if_predictive_selected
		end      
				# hoteles.sort! { |program1,program2| program1.nights <=> program2.nights } con esto se puede ordernar por algun campo del hotel
		return @hoteles  
		[]
	end

	def search_hotels_if_not_predictive
			if Area.exists?(name: word) # Paìses y ciudades con el mismo nombre?
				area = (Area.find_by name: word) # se obtiene el id del area escrita en el search input
				idDestinations = area.destinations.pluck(:id) 
				@hoteles = Hotel.where(:destination_id => idDestinations)
			end
			if Country.exists?(name: word)    # Paìses y ciudades con el mismo nombre?
				pais = (Country.find_by name: word) # se busca el paìs por su nombre
				areas = pais.areas.pluck(:id) # Se traen todas las areas posibles para ese paìs
				destinations = Destination.where(:area_id => areas).pluck(:id)
				@hoteles = Hotel.where(:destination_id => destinations) #Se buscan los programas que tienen como area_id dentro de los id de areas que tiene el país
				p @hoteles
			end
	end 

		def search_hotels_if_predictive_selected
			if type_search == "Country"
				pais = Country.find(id_search) #Se debe buscar el país correspondiente al paràmetro
				areas = pais.areas.pluck(:id)  # Se traen todas las areas posibles para ese paìs
				destinations = Destination.where(:area_id => areas).pluck(:id)
				@hoteles = Hotel.where(:destination_id => destinations) #Se buscan los programas cuyo id_area es uno de las Areas del país
				p @hoteles
			end  
			if type_search == 'Area'
				area = Area.find(id_search)
				destinations = area.destinations.pluck(:id)
				@hoteles = Hotel.where(:destination_id => destinations) # Se buscan los hoteles que tengan id_destination = id_destination
			end
	end

	def search_services
		return [] if word.blank?
		if id_search.blank?
			if Area.exists?(name: word)
				aux = Area.unique_services_by_area_name(word).sort_by(&:category)
				return process_services(aux) unless aux.empty?
			elsif Country.exists?(name: word)
				aux = Country.unique_services_by_country_name(word).sort_by(&:category)
				return process_services(aux) unless aux.empty?
			end   
		else
			type = type_search.camelize.constantize
			aux = type.find(id_search).services.sort_by(&:category).to_a
			return process_services(aux) unless aux.empty?
		end
		[]
	end

	def search_output_groups
		return Program.uniques.output_groups if word.blank?
		if id_search.blank?
			return Area.unique_output_groups_by_area_name(word)       if Area.exists?(name: word)
			return Country.unique_output_groups_by_country_name(word) if Country.exists?(name: word)
		else
			type = type_search.camelize.constantize
			return type.find(id_search).programs.where("programs.expiration_date > ? and programs.output_group = 1", Date.today).uniq.sort_by{|u| u[:nights]}
		end
		[]
	end

	private
		def process_services(aux)
			results = []
			if aux.count == 1
				results[0] = [aux.first]
				results[1] = nil
			elsif aux.count % 2 == 1
				results = aux.each_slice(aux.count/2).to_a
				results[0][results[0].count] = results[2][0]
			else
				results = aux.each_slice(aux.count/2).to_a
			end
			results
		end
end