namespace :tweets do
  desc 'Auto publish tweets for specific politicians'
  task :auto_publish => :environment do
    puts "Start ... "
    pcount = Politician.with_auto_publish.active.count 
    tweets_count=0

    Politician.with_auto_publish.active.each do |politician|
      tweets_count +=politician.deleted_tweets.waiting_review.update_all("reviewed = 1, approved = 1, reviewed_at = '#{Time.now}', reviewed_by_id = 0", 
                              "(modified - created) > #{Admin::SysSetting.auto_publish_delay_seconds}")
      print '#'
    end
    puts "published #{tweets_count} tweets of #{pcount} politicians"
    puts "Done. "
  end
  desc 'Auto reject tweets if the tweep has posted a similar tweet'
  task :auto reject => :environment do
    puts "Start ... "
    deleted_tweets = DeletedTweet.where(:politician_id => Politician.active.all)
    deleted_tweets.where("reviewed_at IS  NULL").where(:reviewed=>false).each do |deleted_tweet|
      tweets = Tweet.where(:politician_id => deleted_tweet.politician_id , :deleted => 0,
      :created => deleted_tweet.created..DateTime.now).order("created ASC").limit(1)
      tweets.each do |tweet|
        deleted_tweet.reviewed_at =  Time.now
        if is_similar(tweet.content.upcase,deleted_tweet.content.upcase) 
           deleted_tweet.reviewed = true
           deleted_tweet.approved = false
           deleted_tweet.reviewed_by = nil
        end
        deleted_tweet.save
      end
    end
    puts "Done. "
  end
  
  desc 'Update the invalid short_url for all tweets'
  task :update_invalid_short_url => :environment do
    puts "Start ... "
    DeletedTweet.update_all("short_url = null", "short_url = 'http://goo.gl/jA3i'")
    puts "Done. "
  end

 

end
