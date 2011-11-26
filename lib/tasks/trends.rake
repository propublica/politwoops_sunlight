namespace :trends do
  desc 'Generate trends'
  task :generate => :environment do
    year = 2011
    month = 9
    tweets = Tweet.deleted.modified_in(year, month)
    
    # get top deleters
    users = {}
    tweets.each do |tweet|
      users[tweet.user_name] = 0 unless users.has_key?(tweet.user_name)
      users[tweet.user_name] += 1 
    end
    p users
    
    # get top deleted parties
    politicians = Politician.where(:user_name => users.keys).includes(:party)
    parties = {}
    politicians.each do |politician|
      parties[politician.party.name] = 0 unless parties.has_key?(politician.party.name)
      parties[politician.party.name] += users[politician.user_name]
    end
    p parties
    
    # get time between posting and deleting
    total_time = 0
    fastest_time = 99999999999999999999999999
    fastest_tweet = nil
    slowest_time = 0
    slowest_tweet = nil
    tweets.each do |tweet|
      time_delay = (tweet.modified.to_time.to_i - tweet.details['created_at'].to_time.to_i)
      total_time += time_delay
      fastest_time = time_delay unless time_delay > fastest_time
      fastest_tweet = tweet unless time_delay > fastest_time
      slowest_time = time_delay if time_delay > slowest_time
      slowest_tweet = tweet if time_delay > slowest_time
    end
    avg_time = (total_time * 1.0) / (tweets.length * 3600.0)
    p avg_time
    p fastest_time
    p fastest_tweet
    p slowest_time
    p slowest_tweet
  end
end