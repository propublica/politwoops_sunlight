namespace :csv do
  desc 'Import A CSV file'
  task :import => :environment do
    require 'csv'
    
    # make separator configurable
    separator = ENV['CSV_SEP'].present? ? ENV['CSV_SEP'] : ';'

    # parse CSV file into structure
    parties = {}
    politicians = {}
    groups = {}
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
       groups[place] = 0 if !groups.has_key?(place)
       groups[place] += 1
       politicians[twitter_user] = {
         :user_name => twitter_user,
         :party => party,
         :group => place
       }
     end
     #p politicians
     #p parties
     #p groups
     
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
     p twitter_user_local_ids
     
     twitter_user_ids = {}
     new_twitter_users.each_slice(75) do |twitter_users|
       # FIXME: lo/hicase of usernmes
       Twitter::users(twitter_users).each { |user| twitter_user_ids[user.screen_name.downcase] = user.id }
       puts "."
       sleep 1
     end

     num = 0
     group_politician_ids = {}
     politicians.keys.each do |twitter_user|
       politician_info = politicians[twitter_user]
       group_politician_ids[politician_info[:group]] = [] if !group_politician_ids.has_key?(politician_info[:group])
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
           group_politician_ids[politician_info[:group]] << p.id
           num += 1
         rescue Twitter::NotFound => e
           puts "Twitter user %s not found !" % twitter_user
         end
       elsif twitter_user_local_ids.has_key?(twitter_user)
         group_politician_ids[politician_info[:group]] << twitter_user_local_ids[twitter_user]
       end
     end
     puts "%d politicians to be added." % num
     
     num = 0
     group_ids = {}
     group_politician_ids.keys.each do |group_name|
       found_groups = Group.where(:name => group_name)
       num += 1
       new_group = Group.new({
         :name => (found_groups.length > 0) ? group_name + "-1" : group_name,
         :language => 'nl',
         :full_name => "Verwijderde tweets van de gemeenteraad van %s" % group_name,
         :sponsor => 'Mede mogelijk gemaakt door: <br /><a href="http://www.politiekonline.nl/"><img src="/images/politiek_online.gif" width="436" height="54" alt="politiek online" /></a><a href="http://www.netdem.nl/"><img src="/images/netdem_small.jpg" width="73" height="77" alt="netwerk democratie" /></a>',
         :politician_ids => group_politician_ids[group_name]
       })
       p group_politician_ids[group_name]
       new_group.save
       group_ids[group_name] = new_group.id
     end
     puts "%d groups were added." % num     
  end
end