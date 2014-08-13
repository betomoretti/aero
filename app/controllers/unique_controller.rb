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
  end

  def send_contact_mail
  end
end
