class TweetDecorator

  def initialize(tweets=nil)
    @tweets = tweets || DeletedTweet
  end

  def paginate_deleted_tweets_for(page, per_page, extra_search=nil, extra_includes=[])
    @tweets.includes([:politician => [:party]].concat(extra_includes)).twoops.where(
      extra_search).paginate(page: page, per_page: per_page)
  end
end
