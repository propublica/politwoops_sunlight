namespace :tweets do
  desc 'Auto publish tweets for specific politicians'
  task :auto_publish => :environment do
    puts "Start ... "
    Politician.with_auto_publish.active.each do |politician|
      politician.deleted_tweets.waiting_review.update_all("reviewed = 1, approved = 1, reviewed_at = '#{Time.now}', reviewed_by_id = 0", 
                              "(modified - created) > #{Admin::SysSetting.auto_publish_delay_seconds}")
      print '#'
    end
    puts ""
    puts "Done. "
  end
  
  desc 'Update the invalid short_url for all tweets'
  task :update_invalid_short_url => :environment do
    puts "Start ... "
    DeletedTweet.update_all("short_url = null", "short_url = 'http://goo.gl/jA3i'")
    puts "Done. "
  end
end