class ErrorsController < ApplicationController
  include ApplicationHelper
  
  def not_found
  	render :template => "errors/not_found", :layout => false
    #render "errors/not_found"
  end

end
