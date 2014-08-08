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
    if params[:search]
      @programs = Program.search(params[:search])
      # @programs = Program.search(params[:search]).order("created_at DESC")
    else
      @programs = Program.uniques
    end
  end

  def show
  end

  def send_contact_mail
  end
end
