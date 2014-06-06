class RequeueTweet < ServiceBase
  include Virtus.model
  attribute :tweet, Tweet
  attribute :queue_name, String

  def call
    decoded = JSON.load(tweet.tweet) # Ensure that it can be decoded.
    if tweet.is_a? DeletedTweet
      decoded = { 'delete' => { 'status' => {
        'id' => decoded['id'],
        'id_str' => decoded['id_str'],
        'user_id' => decoded['user']['id'],
        'user_id_str' => decoded['user']['id_str']
      } } }
    end
    beanstalk = Beanstalk::Pool.new(['localhost:11300'])
    beanstalk.use(queue_name)
    beanstalk.put(JSON.dump(decoded))
    success "Requeued #{tweet.class.table_name.singularize.gsub('_', ' ')} #{tweet.id}"
  end
end

