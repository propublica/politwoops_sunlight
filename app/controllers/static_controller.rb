class StaticController < ApplicationController
  include ApplicationHelper
  
  def about
    render "static/about"
  end

end
