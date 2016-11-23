# encoding: utf-8
class ErrorsController < ApplicationController
  include ApplicationHelper

  def not_found
    render "errors/not_found", :status => 404
  end

  def down
    # We don't generate a 500 here because this is simply for regenerating a
    # static error page.
    render "errors/status_5xx"
  end
end
