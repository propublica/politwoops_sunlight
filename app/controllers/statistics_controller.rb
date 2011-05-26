class StatisticsController < ApplicationController
  before_filter :require_admin_user, :only => [:index]

  def index
    @tweet_statistics = Statistic.where(:what => 'tweets').order('`when` DESC').limit(30).all
    @deleted_tweet_statistics = Statistic.where(:what => 'tweets-deleted').order('`when` DESC').limit(30).all
  end
end
