class Admin::OfficesController < Admin::AdminController

  def list
    @offices = Office.all
    respond_to do |format|
      format.html {render}
    end
  end
  def add
    respond_to do |format|
      format.html {render}
    end

  end

  def save
    office = Office.new(:title => params[:title], :abbreviation => params[:abbreviation])    
    office.save()
    redirect_to "/admin/offices/" 
  end

end


