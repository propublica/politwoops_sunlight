namespace :politicians do
  desc 'Import A CSV file with twitter user plus party indications.'
  task :import_csv => :environment do
    require 'csv'
    separator = ENV['CSV_SEPARATOR'] || ','
    user_row = ENV['USER_ROW'].to_i || 0
    party_row = ENV['PARTY_ROW'].to_i || 1
    CSV.open(ENV['CSV'], 'r', separator) do |row|
      twitter_user = row[user_row].downcase
      twitter_user = twitter_user.gsub(/^(http\:\/\/)?(www\.)?twitter\.com\/?(\/|\@)?/, '')
      twitter_user = twitter_user.gsub(/\/*$/, '')
      politician = Politician.where(:user_name => twitter_user).first
      if politician && politician.update_attributes(:party_id => row[party_row].to_i)
        p twitter_user
      end
    end
  end

  task :reset_avatars => :environment do
    Politician.all.each do |politician|
      last_tweet = Tweet.latest.where(:politician_id => politician.id).first
      if last_tweet
        politician.profile_image_url = last_tweet.details['user']['profile_image_url']
        puts politician.profile_image_url
        politician.save!
      end
    end
  end
end
