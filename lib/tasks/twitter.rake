namespace :twitter do
  desc 'Repost deleted tweets to twitter'
  task :repost => :environment do
    beanstalk = Beanstalk::Pool.new(['127.0.0.1:11300'])
    beanstalk.watch('politwoopsTwitter')
    loop do
      job = beanstalk.reserve
      tweet_id = job.body
      tweet = Tweet.where(:id => tweet_id).includes(:politician => [:groups]).first
      tweet.politician.groups.each do |group|
        # skip group if no credentials are present
        if (group.consumer_key.nil? || group.consumer_secret.nil? || group.oauth_token.nil? || group.oauth_secret.nil? || group.consumer_key.empty? || group.consumer_secret.empty? || group.oauth_token.empty? || group.oauth_secret.empty?)
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
        
        # bitly shortening
        # FIXME: need domain stuff for this
        bitly = Bitly.new($bitly_user, $bitly_apikey)
        short_url = bitly.shorten(group.base_url + '/tweet/' + tweet_id.to_s).short_url
        
        #stuff
        I18n.locale = group.language
        tweet_contents = I18n.t(:retweet_notice, :scope => [:politwoops, :twitter], :politician => tweet.politician.user_name, :tweet_url => short_url).html_safe
        
        @twitter_client.update(tweet_contents)
      end
      job.delete
    end
  end
  
  desc 'Test post for the twitter thinghie'
  task :test_repost => :environment do
    beanstalk = Beanstalk::Pool.new(['127.0.0.1:11300'])
    beanstalk.use('politwoopsTwitter')
    beanstalk.put('73828633311068160')
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