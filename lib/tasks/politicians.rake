namespace :politicians do
  desc 'Import A CSV file'
  task :import => :environment do
    require 'csv'
    
    # make separator configurable
    separator = ENV['CSV_SEP'].present? ? ENV['CSV_SEP'] : ','

    # parse CSV file into structure
    parties = {}
    politicians = {}
    CSV.open(ENV['CSV'], 'r', ENV['CSV_SEP']) do |row|
       twitter_user = row[1].downcase
       twitter_user = twitter_user.gsub(/^(http\:\/\/)?(www\.)?twitter\.com\/?(\/|\@)?/, '')
       twitter_user = twitter_user.gsub(/\/*$/, '')
       party = row[4] ? row[4].downcase : ''
       party = party.gsub(/(\/|\s)/, '-')
       place = row[5].downcase
       #puts "%s - %s - %s" % [twitter_user, party, place]
       parties[party] = 0 if !parties.has_key?(party)
       parties[party] += 1
       politicians[twitter_user] = {
         :user_name => twitter_user,
         :party => party
       }
     end
     #p politicians
     #p parties
     
     party_ids = {}
     num = 0
     parties.keys.each do |party_name|
       found_parties = Party.where(:name => party_name)
       if found_parties.length == 0
         num += 1
         new_party = Party.new({:name => party_name})
         new_party.save
         party_ids[party_name] = new_party.id
       else
         party_ids[party_name] = found_parties[0].id
       end
     end
     puts "%d parties were added." % num
     
     # lookup twitter user names to ids
     new_twitter_users = []
     twitter_user_local_ids = {}
     politicians.keys.each do |twitter_user|
       found_politicians = Politician.where(:user_name => twitter_user)
       if found_politicians.length == 0
         new_twitter_users << twitter_user
       else
         twitter_user_local_ids[twitter_user] = found_politicians[0].id
       end
     end
     # p twitter_user_local_ids
     p new_twitter_users
     
     twitter_user_ids = {}
     new_twitter_users.each_slice(75) do |twitter_users|
       # FIXME: lo/hicase of usernmes
       Twitter::users(twitter_users).each { |user| twitter_user_ids[user.screen_name.downcase] = user.id }
       puts "."
       sleep 1
     end

     num = 0
     politicians.keys.each do |twitter_user|
       politician_info = politicians[twitter_user]
       if twitter_user_ids.has_key?(twitter_user)
         begin
           # FIXME: use Twitter::users in bulk?
           twitter_user_id = twitter_user_ids[twitter_user]          
           #puts twitter_user
           p = Politician.new({
             :user_name => twitter_user,
             :twitter_id => twitter_user_id,
             :party_id => party_ids[politician_info[:party]]
           })
           p.save
           num += 1
         rescue Twitter::NotFound => e
           puts "Twitter user %s not found !" % twitter_user
         end
       end
     end
     puts "%d politicians to be added." % num
  end
  
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
