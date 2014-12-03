class UniqueController < ApplicationController

  layout 'unique'
  
  def index
    render :layout => 'application'  
  end
    
  def search_circuits
    unless params[:word].blank?
      if params[:id_search].blank?
        if Area.exists?(name: params[:word])
          @uniques = Area.uniques_programs_by_area_name(params[:word])
          @word = @uniques.count > 0 ? params[:word] : "No hay resultados para tu búsqueda"
        elsif Country.exists?(name: params[:word])
          @uniques = Country.uniques_programs_by_country_name(params[:word])
          @word = @uniques.count > 0 ? params[:word] : "No hay resultados para tu búsqueda"
        else  
          @uniques = []
          @word = "No hay resultados para tu búsqueda"
        end
      else  
        @id = params[:id_search]
        type = params[:type_search].camelize.constantize
        @uniques = type.find(@id).programs.where("programs.expiration_date > ?", Date.today).uniq.sort_by{|u| u[:nights]}
        @word = @uniques.count > 0 ? params[:word] : "No hay resultados para tu búsqueda"
        @type_search = params[:type_search]
      end
    else  
      @uniques = []
      @word = "No hay resultados para tu búsqueda"
    end
  end

  def search_services
    unless params[:word].blank?
      if params[:id_search].blank?
        if Area.exists?(name: params[:word])
          aux = Area.uniques_services_by_area_name(params[:word]).sort_by(&:category)
          unless aux.empty?
            if aux.count == 1
              @uniques = [aux.first]
              @uniques1 = nil
            elsif aux.count % 2 == 1
              processed = aux.each_slice(aux.count/2).to_a
              processed[0][processed[0].count] = processed[2][0]
              results = processed
              @uniques = results[0] 
              @uniques1 = results[1]
            else
              results = aux.each_slice(aux.count/2).to_a
              @uniques = results[0] 
              @uniques1 = results[1]              
            end
            @word = params[:word]
          else
            @word = "No hay resultados para tu búsqueda"
          end
        elsif Country.exists?(name: params[:word])
          aux = Country.uniques_services_by_country_name(params[:word]).sort_by(&:category)
          unless aux.empty?
            if aux.count == 1
              @uniques = [aux.first]
              @uniques1 = nil
            elsif aux.count % 2 == 1
              processed = aux.each_slice(aux.count/2).to_a
              processed[0][processed[0].count] = processed[2][0]
              results = processed
              @uniques = results[0] 
              @uniques1 = results[1]
            else
              results = aux.each_slice(aux.count/2).to_a
              @uniques = results[0] 
              @uniques1 = results[1]              
            end
            @word = params[:word]
          else
            @word = "No hay resultados para tu búsqueda"
          end
        else  
          results = []
          @word = "No hay resultados para tu búsqueda"
        end
      else  
        @id = params[:id_search]
        type = params[:type_search].camelize.constantize
        aux = type.find(@id).services.sort_by(&:category).to_a
        unless aux.empty?
          if aux.count == 1
            @uniques = [aux.first]
            @uniques1 = nil
          elsif aux.count % 2 == 1
            processed = aux.each_slice(aux.count/2).to_a
            processed[0][processed[0].count] = processed[2][0]
            results = processed
            @uniques = results[0] 
            @uniques1 = results[1]
          else
            results = aux.each_slice(aux.count/2).to_a
            @uniques = results[0] 
            @uniques1 = results[1]              
          end
          @word = params[:word]
        else
          @word = "No hay resultados para tu búsqueda"
        end
      end
    else
      @word = "No hay resultados para tu búsqueda"
    end
  end

  def info
  end

  def contact
  end

  def destinations
    @countries = Country.unique_countries.uniq
  end

  def show
    if params[:id]
      @id = params[:id_search]
      @word = params[:word]
      @type_search = params[:type_search]
      @program = Program.find(params[:id])
      render :layout => 'unique_show'
    else
      redirect_to controller: "unique", action: "index"
    end 
  end

  def send_contact_mail
    ContactUsMailer.contact_us(params[:name], params[:company], params[:email], params[:msg]).deliver
    redirect_to controller: "unique", action: "index"
  end

  def send_program_info
    @program = Program.find(params[:program_id])
    SendProgramMailer.send_program(params[:email], @program).deliver
    render nothing: true
  end

  def send_services_info
    @services = Service.where(:id => params[:ids]).map { |s| s }
    SendServicesMailer.send_services(params[:email], @services).deliver
    render nothing: true
  end

  def autocomplete
    names_circuits = Program.json_for_autocomplete(params[:term])
    names_services = Service.json_for_autocomplete(params[:term])
    names = names_circuits+names_services
    respond_to do |format|
      format.html
      format.json { 
        render json: names.uniq
      }
    end
  end

  def show_pdf
    @program = Program.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "#{@program.id}",
                :page_size => 'A4',
                :page_width => 100,
                :margin => {:top                => 0,
                           :bottom             => 0,
                           :left               => 0,
                           :right              => 0}
      end
    end
  end

  def show_country_pdf
    @country = Country.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "#{@country.id}",
                :page_size => 'A4',
                :page_width => 100,
                :margin => {:top                => 0,
                           :bottom             => 0,
                           :left               => 0,
                           :right              => 0}
      end
    end
  end
end
