# encoding: utf-8
class PartiesController < ApplicationController
  include ApplicationHelper

  before_filter :enable_pager
  before_filter :enable_filter_form

  def show    
    politicians = Party.active_politicians_of(params[:name]).map(&:id)
    @tweets = TweetDecorator.paginate_deleted_tweets_for(params[:page], @per_page, {politician_id: politicians})

    render "tweets/index"
  end
end
