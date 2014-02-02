# encoding: utf-8
class ErrorsController < ApplicationController
  include ApplicationHelper
  
  def not_found
    render "errors/not_found"
  end

  def down
    render "errors/status_5xx"
  end
end
