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
      @word = params[:word]
      if Area.exists?(name: params[:word])
        @uniques = Area.find_by(name: params[:word]).programs.uniq.sort_by{|u| u[:nights]}
      elsif Country.exists?(name: params[:word])
        @uniques = Country.find_by(name: params[:word]).programs.uniq.sort_by{|u| u[:nights]}
      else  
        @uniques = Program.uniques
        @word = "Todos"
      end
    end
  end

  def show
    if params[:id]
      @word = params[:word]
      @program = Program.find(params[:id])
      @hostname = "10.0.0.230"
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
end
