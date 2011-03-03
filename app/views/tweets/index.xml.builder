xml.rss "version" => "2.0" do
  xml.channel do
    xml.title "Politwoops"
    xml.description "Alle deleted tweets van politici"
    xml.link root_url
    @tweets.each do |tweet|
      xml.item do
        xml.title tweet.user_name + ': ' + tweet.content
        xml.description tweet.user_name + ': ' + tweet.content
        xml.link url_for :controller => 'tweets', :action => 'show', :id => tweet.id, :only_path => false
      end
    end
  end
end