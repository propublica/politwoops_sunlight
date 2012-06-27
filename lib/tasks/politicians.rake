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
    no_responses = []
    politicians = Politician

    if ENV['where_blank'].present?
      politicians = politicians.where :profile_image_url => nil
    end

    if ENV['username']
      politicians = politicians.where :user_name => ENV['username']
    end

    politicians.all.each do |politician|
      url = "http://api.twitter.com/1/users/profile_image/#{politician.user_name}?size=bigger"

      begin
        res = HTTParty.get url, :no_follow => true
      rescue HTTParty::RedirectionTooDeep => e
        image_url = e.response.header['Location']
        if image_url and image_url.strip.present?
          puts "[#{politician.user_name}] #{image_url}"
          politician.profile_image_url = image_url
          politician.save!
        else
          no_responses << politician.user_name
          puts "[#{politician.user_name}] No image URL, probably bad account"
        end
      else
        "[#{politician.user_name}] NO RESPONSE??"
      end

      sleep 1
    end

    no_responses.each do |name|
      puts "Possible bad username: #{name}"
    end
  end
end
