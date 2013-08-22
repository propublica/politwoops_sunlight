namespace :tweets do
  desc 'Auto publish tweets for specific politicians'
  task :auto_publish => :environment do
    puts "Start ... "
    Politician.with_auto_publish.each do |politician|
      approved_tweets = politician.deleted_tweets.waiting_review.where().select(:id).collect(&:id)
      
      if approved_tweets.any?
        DeletedTweet.update_all("reviewed = 1, approved = 1, reviewed_at = '#{Time.now}', reviewed_by_id = 0", 
                                "(modified - created) / 1000 > #{Admin::SysSetting.auto_publish_delay_seconds}")
      end
      
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