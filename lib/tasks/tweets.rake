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
  
  desc 'Update the invalid short_url for all tweets'
  task :update_invalid_short_url => :environment do
    puts "Start ... "
    DeletedTweet.update_all("short_url = null", "short_url = 'http://goo.gl/jA3i'")
    puts "Done. "
  end
end