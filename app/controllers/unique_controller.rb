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
      @uniques = Program.search_uniques(params[:word])
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
      render :layout => 'unique_show'
    else
      redirect_to controller: "unique", action: "index"
    end 
  end

  def send_contact_mail
  end
end
