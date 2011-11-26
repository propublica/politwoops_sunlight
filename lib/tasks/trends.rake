namespace :trends do
  desc 'Generate trends'
  task :generate => :environment do
    year = 2011
    month = 10
    tweets = Tweet.deleted.modified_in(year, month)
    
    # get top deleters
    users = {}
    tweets.each do |tweet|
      users[tweet.user_name] = 0 unless users.has_key?(tweet.user_name)
      users[tweet.user_name] += 1 
    end
    sorted_users = users.sort { |x,y| y[1] <=> x[1] }
    p sorted_users
    t = Trend.new({
      :year => year,
      :month => month,
      :name => 'top_deleters',
      :value => sorted_users.slice(0, 5)
    })
    t.save
    
    # get top deleted parties
    politicians = Politician.where(:user_name => users.keys).includes(:party)
    parties = {}
    politicians.each do |politician|
      parties[politician.party.name] = 0 unless parties.has_key?(politician.party.name)
      parties[politician.party.name] += users[politician.user_name]
    end
    sorted_parties = parties.sort { |x,y| y[1] <=> x[1] }
    p sorted_parties
    t = Trend.new({
      :year => year,
      :month => month,
      :name => 'top_party_deleters',
      :value => sorted_parties.slice(0, 5)
    })
    t.save
    
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
    t = Trend.new({
      :year => year,
      :month => month,
      :name => 'delete_lag',
      :value => {
        :avg_time => avg_time,
        #:slowest_time => slowest_time,
        #:slowest_id => slowest_tweet.id.to_s
        :fastest_time => fastest_time,
        :fastest_tweet => fastest_tweet.id.to_s
      }
    })
    t.save
    
    # top days
    days = {0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0}
    tweets.each do |tweet|
      days[tweet.details['created_at'].to_time.to_date.wday] += 1
    end
    p days
    t = Trend.new({
      :year => year,
      :month => month,
      :name => 'days',
      :value => days
    })
    t.save
    
    word_frequencies = Hash.new(0)
    tweets.each do |tweet|
      words = tweet.content.split(/\W/).select { |w| w.length > 0 }
      words.each { |w| word_frequencies[w] += 1 }
    end
    p word_frequencies
    sorted_words = word_frequencies.sort { |x,y| y[1] <=> x[1] }
    t = Trend.new({
      :year => year,
      :month => month,
      :name => 'words',
      :value => sorted_words.slice(0, 50)
    })
    t.save
  end
end