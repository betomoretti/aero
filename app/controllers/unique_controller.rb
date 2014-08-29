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
  end

  def search
    if params[:word]
      @uniques = Program.search_uniques(params[:word]).uniq
      @word = params[:word]
    else
      @uniques = Program.uniques
      @word = "Todos"
    end
  end

  def show
    if params[:id]
      @word = params[:word]
      @program = Program.find(params[:id])
      @hostname = request.host<<":"<<4000.to_s || "www.aerolaplata.com.ar"
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
    @uniques = Program.json_for_autocomplete
    respond_to do |format|
      format.html
      format.json { 
        render json: @uniques
      }
    end
  end
end
