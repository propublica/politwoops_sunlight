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
 
    separator = ENV['CSV_SEPARATOR'] || ','
    csv_file=ENV['CSV'] || 'egytweeps.csv'
    links = []
    usernames = {}

    #Expected:
    # serial, twitter_handler, image_url, position, party_name, suffix, first_name, middle_name, last_name, twitter_url
    # example:
    #1,ElBaradei,https://si0.twimg.com/profile_images/2323143814/w8adhyx5nomw2rj2yp2u.jpeg,مؤسس,الدستور,
    #د.,محمد,,البرادعي,https://twitter.com/ElBaradei


    puts "Reading CSV Files #{csv_file}"

    CSV.open(csv_file, 'r', separator) do |row|
      
      serial, twitter_user, image_url, office_title, party_name, suffix, first_name, middle_name, last_name, twitter_url = row
      next if serial.to_i.zero? or twitter_user.blank?

      #Cleaning
      [serial, twitter_user, image_url, office_title, party_name, suffix, 
        first_name, middle_name, last_name, twitter_url].each do |x|
          x.strip! unless x.nil?
        end

      pol = { 'user_name' => twitter_user} 

      pol.merge!({
          'image_url'=>image_url,
          'suffix'=>suffix,
          'first_name'=>first_name,
          'middle_name'=>middle_name,
          'last_name'=>last_name,
          'twitter_url' => twitter_url ,
          'office_title'=> office_title,
          'party_name'=>party_name
        })
      
      usernames[twitter_user.downcase] = pol
      print "."
    end   # Ending CSV Parsing

    twitter_users = Twitter::users(usernames.keys)
    puts "\ntwitter user length %s, processing tweeps data" % twitter_users.length
    twitter_users.each do |tu| 
        pol = usernames[tu.screen_name.downcase]
        pol['twitter_id'] = tu.id

        office = nil
        office_title = pol['office_title']
        office = Office.find_or_create_by_title(office_title, {:abbreviation=>office_title}) unless office_title.blank?

        party=nil
        party_name = pol['party_name']
        party=Party.find_or_create_by_name(party_name, :display_name=>party_name) unless party_name.blank?
      
        newpol = Politician.where(:twitter_id => pol['twitter_id'], :user_name => pol['user_name']).first_or_create()
        newpol.first_name = pol['first_name']
        newpol.middle_name = pol['middle_name']
        newpol.last_name = pol['last_name']
        newpol.suffix = pol['suffix']
        newpol.profile_image_url = pol['image_url']
        newpol.office = office
        newpol.state = pol['state']
        newpol.account_type = pol['account']
        newpol.party = party
        newpol.save()   
        print '.'
    end
    # #after all new users are entered, link them
    # #no longer used with the new format
    # links.each do |l|
    #     p1 = Politician.where(:user_name => l[0]).first
    #     p2 = Politician.where(:user_name => l[1]).first
    #     p1.add_related_politician(p2)    
    # end
    puts "\nDone"
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
