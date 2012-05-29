module TweetsHelper
  def format_user_name(tweet_content)
    tweet_content.gsub(/(@(\w+))/, %Q{<a href="http://twitter.com/\\2" target="_blank">\\1</a>})
  end
  
  def format_hashtag(tweet_content)
    tweet_content.gsub(/(#(\w+))/, %Q{<a href="https://twitter.com/#!/search?q=%23\\2" target="_blank">\\1</a>})
  end
  
  def format_tweet(tweet)
    content = auto_link(format_user_name(format_hashtag(tweet.content)), :html => { :target => '_blank' })
  end

  def avatar_url(username)
    "http://img.tweetimag.es/i/#{username}_b"
  end

end
