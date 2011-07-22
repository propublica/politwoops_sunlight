class StatisticsController < ApplicationController
  before_filter :require_admin_user, :only => [:index]

  def index
    # select created, hour(created), count(*) from tweets where (created > date_sub(now(), interval 1 day)) group by hour(created) order by created;
    @tweet_hourly_statistics = Tweet.connection.select_all("select hour(created) AS hour_of_day, count(*) AS num from tweets where (created > date_sub(now(), interval 1 day)) group by hour(created) order by created;")
    @tweet_statistics = Statistic.where(:what => 'tweets').order('`when` DESC').limit(30).all
    @deleted_tweet_statistics = Statistic.where(:what => 'tweets-deleted').order('`when` DESC').limit(30).all
    @politician_statistics = Statistic.where(:what => 'politicians').order('`when` DESC').limit(30).all
  end
end
