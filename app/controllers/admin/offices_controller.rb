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
    if params[:obj_id] then
      @office = Office.find(params[:obj_id].to_i)
      @office.title = params[:title]
      @office.abbreviation = params[:abbreviation]
    else
      @office = Office.new(:title => params[:title], :abbreviation => params[:abbreviation])       
    end
    

    if @office.save
      redirect_to "/admin/offices/" 
    else
      render 'add'
    end
  end

  def edit
    @office = Office.find(params[:id])
    respond_to do |format|
      format.html {render}
    end
  end

end


