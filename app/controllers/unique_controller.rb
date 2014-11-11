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
          @word = params[:word]
        elsif Country.exists?(name: params[:word])
          @uniques = Country.uniques_programs_by_country_name(params[:word])
          @word = params[:word]
        else  
          @uniques = []
          @word = "No hay resultados para tu búsqueda"
        end
      else  
        @id = params[:id_search]
        type = params[:type_search].camelize.constantize
        @uniques = type.find(@id).programs.uniq.sort_by{|u| u[:nights]}
        @word = params[:word]
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
          aux = Area.uniques_services_by_area_name(params[:word])
          results = aux.each_slice(aux.count/2).to_a
          @uniques = results[0]
          @uniques1 = results[1]
          @word = params[:word]
        elsif Country.exists?(name: params[:word])
          aux = Country.uniques_services_by_country_name(params[:word])
          results = aux.each_slice(aux.count/2).to_a
          @uniques = results[0]
          @uniques1 = results[1]
          @word = params[:word]
        else  
          results = []
          @word = "No hay resultados para tu búsqueda"
        end
      else  
        @id = params[:id_search]
        type = params[:type_search].camelize.constantize
        aux = type.find(@id).services
        results = aux.each_slice(aux.count/2).to_a
        @uniques = results[0]
        @uniques1 = results[1]
        @word = params[:word]
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

  def search
    unless params[:word].blank?
      if params[:id_search].blank?
        if Area.exists?(name: params[:word])
          @uniques = Area.find_by(name: params[:word]).programs.uniq.sort_by{|u| u[:nights]}
          @word = params[:word]
        elsif Country.exists?(name: params[:word])
          @uniques = Country.find_by(name: params[:word]).programs.uniq.sort_by{|u| u[:nights]}
          @word = params[:word]
        else  
          @uniques = []
          @word = "No hay resultados para tu búsqueda"
        end
      else  
        @id = params[:id_search]
        type = params[:type_search].camelize.constantize
        @uniques = type.find(@id).programs.uniq.sort_by{|u| u[:nights]}
        @word = params[:word]
        @type_search = params[:type_search]
      end
    else  
      @uniques = []
      @word = "No hay resultados para tu búsqueda"
    end
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
