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
    if (Time.now - tweet.modified).to_i > (60 * 60 * 24 * 365)
      tweet_time = tweet.modified.strftime("%l:%M %p")
      tweet_date = tweet.modified.strftime("%d %b %y") # 03 Jun 12
      tweet_when = "at <a class=""linkUnderline"" href=""/tweet/#{tweet.id}"">#{tweet_time} on #{tweet_date}</a>"
    elsif (Time.now - tweet.modified).to_i > (60 * 60 * 24)
      tweet_time = tweet.modified.strftime("%l:%M %p")
      tweet_date = tweet.modified.strftime("%d %b") # 03 Jun
      tweet_when = "at <a class=""linkUnderline"" href=""/tweet/#{tweet.id}"">#{tweet_time} on #{tweet_date}</a>"
    else
      since_tweet = time_ago_in_words tweet.modified
      tweet_when = "<a class=""linkUnderline"" href=""/tweet/#{tweet.id}"">#{since_tweet}</a> ago"
    end
    delete_delay = (tweet.modified - tweet.created).to_i
    
    delay = if delete_delay > (60 * 60 * 24 * 7)
      "after #{pluralize(delete_delay / (60 * 60 * 24 * 7), "week")}"
    elsif delete_delay > (60 * 60 * 24)
      "after #{pluralize(delete_delay / (60 * 60 * 24), "day")}"
    elsif delete_delay > (60 * 60)
      "after #{pluralize(delete_delay / (60 * 60), "hour")}"
    elsif delete_delay > 60
      "after #{pluralize(delete_delay / 60, "minute")}"
    elsif delete_delay > 1
      "after #{pluralize delete_delay, "second"}"
    else
      "immediately"
    end

    if tweet.retweeted_id.nil?
      rt_text = ""
    else
      orig_url = twitter_url(tweet.retweeted_user_name, tweet.retweeted_id)
      rt_text = "<a href=""#{orig_url}"">Original tweet by @#{tweet.retweeted_user_name}</a>."
    end

    if html
      source = tweet.details["source"].to_s.html_safe
      byline = "<a href=\"http://twitter.com/#{tweet.politician.user_name}\" class=\"twitter\">#{tweet.details['user']['name']}</a>".html_safe
      byline += t(:byline,
                  :scope => [:politwoops, :tweets],
                  :retweet => rt_text,
                  :when => tweet_when,
                  :what => source,
                  :delay => delay).html_safe
      byline
    else
      t :byline_text, :scope => [:politwoops, :tweets], :when => tweet_when, :delay => delay
    end
  end

  def rss_date(time)
    time.strftime "%a, %d %b %Y %H:%M:%S %z"
  end

end
