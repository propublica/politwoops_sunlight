class RequeueTweet < ServiceBase
  include Virtus.model
  attribute :tweet, Tweet
  attribute :queue_name, String

  def call
    JSON.load(tweet.tweet) # Ensure that it can be decoded.
    beanstalk = Beanstalk::Pool.new(['localhost:11300'])
    beanstalk.use(queue_name)
    beanstalk.put(tweet.tweet)
    success "Requeued tweet #{tweet.id}"
  end
end

