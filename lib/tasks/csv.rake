namespace :csv do
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
end