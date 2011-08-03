namespace :twitter do
  desc 'Repost deleted tweets to twitter'
  task :repost => :environment do
    beanstalk = Beanstalk::Pool.new(BEANSTALKD_SERVERS)
    beanstalk.watch('channelCounters')
    loop do
      job = beanstalk.reserve
      tweet_id = JSON.parse(job.body)
      tweet = Tweet.where(:id => tweet_id).includes(:politician => [:groups]).first
      tweet.politician.groups.each do |group|
        # skip group if no credentials are present
        if (group.consumer_key.empty? || group.consumer_secret.empty? || group.oauth_token.empty? || group.oauth_secret.empty?)
          next
        end
        
        #connection to Twitter
        Twitter.configure do |config|
          config.consumer_key       = group.consumer_key
          config.consumer_secret    = group.consumer_secret
          config.oauth_token        = group.oauth_token
          config.oauth_token_secret = group.oauth_secret
        end
        @twitter_client = Twitter::Client.new
        
        #stuff
      end
      job.delete
    end
  end
  
  desc 'Import a Twitter list'
  task :sync_list => :environment do
    puts "Getting lists for:"
    puts ENV['TWITTER_USER']
    puts ENV['TWITTER_LIST']
    next_cursor = -1
    params = {
      :politician_ids => []
    }
    until next_cursor == 0
      m = Twitter.list_members(ENV['TWITTER_USER'], ENV['TWITTER_LIST'], :cursor => next_cursor)
      m.users.each do |user|
        p = Politician.new({
          :user_name => user.screen_name,
          :twitter_id => user.id,
          :party_id => ENV['PARTY_ID']
        })
        if p.valid? && p.save
          puts "* " + user.screen_name
          politician_id = p.id
        else
          puts "  " + user.screen_name
          politician_id = Politician.where(:user_name => user.screen_name).first.id
        end
        params[:politician_ids] << politician_id
      end
      next_cursor = m.next_cursor
    end
    # empty the group from politicians
    empty_params = {
      :politician_ids => []
    }
    g = Group.find(ENV['GROUP_ID'])
    g.update_attributes(empty_params)
    # and add them back again
    g.update_attributes(params)
  end
end