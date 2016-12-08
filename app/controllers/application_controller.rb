# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  # let tweet helper methods be available in the controller
  helper TweetsHelper

  before_filter :donor_banner

  rescue_from ActiveRecord::RecordNotFound, :with => :file_not_found

  def file_not_found
    respond_to do |format|
      format.html { render :file => "public/404.html", :status => 404}
    end
  end

  def donor_banner
    @donor_banner_enabled = Settings.fetch(:enable_donor_banner, false)
  end

  # needs to become more dynamic somehow
  def set_locale
    # not sure what this does
    I18n::Backend::Simple.send(:include, I18n::Backend::Flatten)
    I18n.locale = "en"
  end

  def enable_filter_form
    @states = Politician.where("state IS NOT NULL").pluck(:state).uniq
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
