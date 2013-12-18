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
    require 'twitter'
 
    #expected format is Name (not used, placeholder ), Office, State, Twitter Username, Party, Account Type, Linked Twitter Accounts
    separator = ENV['CSV_SEPARATOR'] || ','
    links = []
    usernames = {}

    CSV.open(ENV['CSV'], 'r', separator) do |row|
    
      #skip header row if it exists
      if row[0] == 'First Name' then
        next
      end 

      twitter_user = row[6].downcase.strip
      if row[4] then
        office = Office.where(:title => row[4].downcase.strip).first
      end

      if row[0] then
        first = row[0].strip
      end
    
      if row[1] then
        middle = row[1].strip
      end

      if row[2] then
        last = row[2].strip
      end
    
      if row[3] then
        suffix = row[3].strip
      end

      if row[5] then 
        state = row[5].upcase.strip
      end
      
      if row[7] then 
        party = Party.where(:name => row[7].strip).first
      end

      if row[8] then 
        account = AccountType.where(:name => row[8].downcase.strip).first
      end
     
      if row[9] then  
        for l in row[9].split('|')
          links.push([ twitter_user, l.downcase.strip ])
        end
      end

      pol = { 'user_name' => twitter_user} 
      pol['first_name'] = first || nil
      pol['middle_name'] = middle || nil
      pol['last_name'] = last || nil
      pol['suffix'] = suffix || nil
      pol['office'] = office || nil
      pol['state'] = state || nil
      pol['account'] = account || nil
      pol['party'] = party || nil
      usernames[twitter_user] = pol
    end   

    twitter_users = Twitter::users(usernames.keys)
    puts "twitter user length %s" % twitter_users.length
    twitter_users.each do |tu| 
#    usernames.keys.each do |name|       
#        pol = usernames[name]
        pol = usernames[tu.screen_name.downcase]
        pol['twitter_id'] = tu.id
      
#        newpol = Politician.where(:user_name => name).first 
        newpol = Politician.where(:twitter_id => pol['twitter_id'], :user_name => pol['user_name']).first_or_create()
        newpol.first_name = pol['first_name']
        newpol.middle_name = pol['middle_name']
        newpol.last_name = pol['last_name']
        newpol.suffix = pol['suffix']
        newpol.office = pol['office']
        newpol.state = pol['state']
        newpol.account_type = pol['account']
        newpol.party = pol['party']
        newpol.save()   
        
    end

    #after all new users are entered, link them
    links.each do |l|
        p1 = Politician.where(:user_name => l[0]).first
        p2 = Politician.where(:user_name => l[1]).first
        p1.add_related_politician(p2)    
    end
  end

  desc "Updates profile images for politicians."
  task :reset_avatars => :environment do
    politicians = Politician

    force = ENV.fetch('force', false)

    if ENV['where_blank'].present?
      politicians = politicians.where :profile_image_url => nil
    end

    if ENV['username']
      politicians = politicians.where :user_name => ENV['username']
    end

    force = false
    if ENV['force'].present?
      force = true
    end

    delay = 2.to_f
    politicians.all.each do |politician|
      begin
        updated, error = politician.reset_avatar :force => force
        if updated == true
          puts "[#{politician.user_name}] #{politician.profile_image_url}"
        else
          puts "[#{politician.user_name}] #{error}"
          delay = [15, delay * 1.5].min
          puts "Delay increased to #{delay} seconds."
        end
      rescue Twitter::Error::TooManyRequests => error
        sleep error.rate_limit.reset_in + 1
        retry
      end
      sleep delay
    end
  end
end
