 class SearchForm
  include ActiveModel::Model
  attr_accessor :word,:option_select, :id_search, :type_search


  def search_circuits
    return [] if word.blank?
    if id_search.blank?
      return Area.unique_programs_by_area_name(word)       if Area.exists?(name: word)
      return Country.unique_programs_by_country_name(word) if Country.exists?(name: word)
    else
      type = type_search.camelize.constantize
      return type.find(id_search).programs.where("programs.expiration_date > ?", Date.today).uniq.sort_by{|u| u[:nights]}
    end
    []
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