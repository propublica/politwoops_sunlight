class ErrorsController < ApplicationController
  include ApplicationHelper
  
  def not_found
    render "errors/not_found"
  end

end
