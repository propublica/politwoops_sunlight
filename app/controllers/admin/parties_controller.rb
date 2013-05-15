class Admin::PartiesController < Admin::AdminController

  def list
    @parties = Party.all
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
      @party = Party.find(params[:obj_id].to_i)
      @party.name = params[:name]
      @party.display_name = params[:display_name]
    else
      @party = Party.new(:name => params[:name], :display_name => params[:display_name])       
    end
    if @party.save
      redirect_to "/admin/parties/" 
    else
      render 'add'
    end
    
  end

  def edit
    @party = Party.find(params[:id])
    respond_to do |format|
      format.html {render}
    end
  end

end


