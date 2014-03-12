class TweetDecorator

  def self.paginate_deleted_tweets_for(page, per_page, extra_search=nil)
    DeletedTweet.includes(:politician => [:party]).twoops.where(
      extra_search).paginate(page: page, per_page: per_page)
  end
end
