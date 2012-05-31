xml.rss "version" => "2.0" do
  xml.channel do
    if @politician
      xml.title "Politwoops - Tweets by @#{@politician.user_name}"
      xml.link politician_url(@politician.user_name)
    elsif @query
      xml.title "Politwoops - Tweets matching \"#{@query}\""
      xml.link root_url(:q => @query)
    else
      xml.title "Politwoops"
      xml.link root_url
    end

    xml.description t(:slogan, :scope => :politwoops)

    @tweets.each do |tweet|
      xml.item do
        xml.title "@#{tweet.user_name} -- #{byline tweet, false}"
        xml.description tweet.content
        xml.link tweet_url(tweet)
        xml.pubDate rss_date(tweet.modified)
      end
    end
  end
end