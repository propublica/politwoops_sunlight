# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  # let tweet helper methods be available in the controller
  helper TweetsHelper

  before_filter :donor_banner

  private

  def donor_banner
    @donor_banner_enabled = Settings.fetch(:enable_donor_banner, false)
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def enable_pager
    @per_page_options = [10, 20, 50]
    @per_page = closest_value((params.fetch :per_page, 0).to_i, @per_page_options)
    @page = [params[:page].to_i, 1].max
  end

  def enable_filter_form
    @states = State.all
    @parties = Party.all
    @politicians = Politician.active
    @filters = {'state' => nil, 'party' => nil }

    filters = {
      state: { key_to_use: :state, value_to_use: params[:state], name: params[:state] },
      party: { key_to_use: :party_id, value_to_use: Party.by_name(params[:party]), name: params[:party] }
    }
    
    filters.each do |key, value|
      if !params.fetch(key, '').empty?
        apply_filter(key, value) 
      end
    end
  end

  def apply_filter(key, options)
    @politicians = @politicians.where(options[:key_to_use] => options[:value_to_use])
    @filters[key.to_s] = options[:name]
  end
end
