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
    @states = Politician.where("state IS NOT NULL").all(:select => "DISTINCT(state)").map do |row|
      row.state
    end
    @states = @states.sort

    @parties = Party.all
    @offices = Office.all

    @politicians = Politician.active

    #check for filters
    @filters = {'state' => nil, 'party' => nil, 'office' => nil  }
    unless params.fetch('state', '').empty?
        @politicians = @politicians.where(:state => params[:state])
        @filters['state'] = params[:state]
    end
    unless params.fetch('party', '').empty?
        party = Party.where(:name => params[:party])[0]
        @politicians = @politicians.where(:party_id => party)
        @filters['party'] = party.name
    end
    unless params.fetch('office', '').empty?
        @politicians = @politicians.where(:office_id => params[:office])
        @filters['office'] = params[:office]
    end
  end

end
