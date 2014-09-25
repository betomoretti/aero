class UniqueController < ApplicationController

  layout 'unique'
  
  def index
    render :layout => 'application'  
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

  def autocomplete
    names = Program.json_for_autocomplete(params[:term])
    respond_to do |format|
      format.html
      format.json { 
        render json: names
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
