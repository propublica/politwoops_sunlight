namespace :politicians do
  desc 'Import A CSV file with twitter user plus party indications.'
  task :import_csv => :environment do

    require 'csv'

    #expected format is Name (not used, placeholder ), Office, State, Twitter Username, Party, Account Type, Linked Twitter Accounts
    separator = ENV['CSV_SEPARATOR'] || ','
    links = []

    CSV.open(ENV['CSV'], 'r', separator) do |row|
    
      #skip header row if it exists
      if row[0] == 'Name' then
        next
      end 

      twitter_user = row[3].downcase.strip
      if row[1] then
        office = Office.where(:title => row[1].downcase.strip)
      end
       
      state = row[2].upcase.strip
      
      if row[4] then 
        party = Party.where(:name => row[4].strip)
      end

      if row[5] then 
        account = AccountType.where(:type => row[5].downcase.strip)
      end
     
      if row[6] then  
        for l in row[6].split('|')
          links.push([ twitter_user, l.downcase.strip ])
        end
      end

      pol = Politician.where(:user_name => twitter_user).first_or_create(:locked => true)
      pol.office = office
      pol.state = state
      pol.account = account
      pol.party = party
      pol.save()
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
