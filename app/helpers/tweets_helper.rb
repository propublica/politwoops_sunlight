# encoding: utf-8
module TweetsHelper
  def format_user_name(tweet_content)
    tweet_content.gsub(/(@(\w+))/, %Q{<a href="http://twitter.com/\\2" target="_blank">\\1</a>})
  end
  
  def format_hashtag(tweet_content)
    tweet_content.gsub(/(#(\w+))/, %Q{<a href="https://twitter.com/#!/search?q=%23\\2" target="_blank">\\1</a>})
  end

  def format_retweet_prefix (content, user_name)
    "RT @#{user_name}: #{content}"
  end
  
  def format_tweet(tweet)
    if tweet.retweeted_id.nil?
      content = tweet.content
    else
      content = format_retweet_prefix(tweet.retweeted_content,
                                      tweet.retweeted_user_name)
    end
    content = format_hashtag(content)
    content = format_user_name(content)
    content = auto_link(content, :html => { :target => '_blank' })
  end

  def twitter_url (tweet_user_name, tweet_id)
    "http://www.twitter.com/#{tweet_user_name}/status/#{tweet_id}"
  end

  def byline(tweet, html = true)
    since_tweet = time_ago_in_words tweet.modified
    tweet_when = "<a class=""linkUnderline"" href=""/tweet/#{tweet.id}"">#{since_tweet}</a>"

    delay = distance_of_time_in_words(tweet.modified, tweet.created)

    if tweet.retweeted_id.nil?
      rt_text = ""
    else
      orig_url = twitter_url(tweet.retweeted_user_name, tweet.retweeted_id)
      rt_text = "<a href=""#{orig_url}"">Original tweet by @#{tweet.retweeted_user_name}</a>."
    end

    if html
      source = tweet.details["source"].to_s.html_safe
      t(:byline,
        :scope => [:politwoops, :tweets],
        :retweet => rt_text,
        :when => tweet_when,
        :what => source,
        :delay => delay).html_safe
    else
      t :byline_text, :scope => [:politwoops, :tweets], :when => tweet_when, :delay => delay
    end
  end

  def rss_date(time)
    time.strftime "%a, %d %b %Y %H:%M:%S %z"
  end

end
