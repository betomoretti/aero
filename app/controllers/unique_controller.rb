class UniqueController < ApplicationController

  layout 'unique'
  
  def index
    render :layout => 'application'  
  end

  def search_hotels
    p params
    @form = SearchForm.new(word: params[:word],option_select: params[:option_select],id_search: params[:id_search],type_search: params[:type_search])
    @uniques = @form.search_hotels
    @word = @uniques.count > 0 ? params[:word] : "No hay resultados para tu búsqueda"
  end  


  def search_circuits
    p params
    @form = SearchForm.new(word: params[:word],option_select: params[:option_select],id_search: params[:id_search],type_search: params[:type_search])
    @uniques = @form.search_circuits
    @word = @uniques.count > 0 ? params[:word] : "No hay resultados para tu búsqueda"
  end
  
  def search_output_groups
    @form = SearchForm.new(word: params[:word],option_select: params[:option_select],id_search: params[:id_search],type_search: params[:type_search])
    @uniques = @form.search_output_groups
    @word = @uniques.count > 0 ? params[:word] : "No hay resultados para tu búsqueda"
    render "search_circuits"
  end

  def search_services
    @form = SearchForm.new(word: params[:word],option_select: params[:option_select],id_search: params[:id_search],type_search: params[:type_search])
    results = @form.search_services
    @uniques = results[0] 
    @uniques1 = results[1] 
    @word = !@uniques.nil? && @uniques.count > 0 ? params[:word] : "No hay resultados para tu búsqueda"
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
