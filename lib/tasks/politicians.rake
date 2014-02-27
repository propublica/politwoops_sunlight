class ImportPoliticians

  def initialize
    @parties = {}
    @politicians = {}
    @party_ids = {}
    @twitter_user_ids = {}
  end

  def import_from_csv(separator)
    CSV.foreach(ENV['CSV'], headers: true, col_sep: separator) do |row|
      name = row['Nombre'].split.reverse
      first_name = name.pop

      case name.size
      when 1
        last_name = name.pop
      when 2
        second_name = name.pop
        last_name = name.pop
      else
        second_name = name.pop
        last_name = name.reverse.join(' ')
      end

      twitter_user = row['Twitter_ID'].downcase.gsub(/^(http\:\/\/)?(www\.)?twitter\.com\/?(\/|\@)?/, '').gsub(/\/*$/, '').strip
      gender = row['Genero']
      party = row['Partido'] ? row['Partido'].downcase.gsub(/(\/|\s)/, '-') : ''
      place = row['Ciudad'] ? row['Ciudad'].downcase : ''

      @parties[party] = 0 if !@parties.has_key?(party)
      @parties[party] += 1
      @politicians[twitter_user] = {
        user_name: twitter_user,
        first_name: first_name,
        middle_name: second_name,
        last_name: last_name,
        party: party
      }
    end

    get_parties
    puts "%d parties were added." % @party_ids.size

    get_twitter_users

    create_politicians
    puts "%d politicians to be added." % @politicians.size
  end

  private

  def get_twitter_users
    # lookup twitter user names to ids
    inexistent_twitter_users.each_slice(75) do |twitter_users|
      twitter_client.users(twitter_users).each { |user| @twitter_user_ids[user.screen_name.downcase] = user.id }
      puts "."
      sleep 1
    end
  end

  def get_parties
    @parties.keys.each do |party_name|
      found_parties = Party.where(:name => party_name)
      if found_parties.length == 0
        @party_ids[party_name] = Party.create({:name => party_name}).id
      else
        @party_ids[party_name] = found_parties[0].id
      end
    end
  end

  def create_politicians
    @politicians.keys.each do |twitter_user|
      politician_info = @politicians[twitter_user]
      if @twitter_user_ids.has_key?(twitter_user)
        begin
          # FIXME: use Twitter::users in bulk?
          twitter_user_id = @twitter_user_ids[twitter_user]
          Politician.create({
            user_name: twitter_user,
            first_name: politician_info[:first_name],
            middle_name: politician_info[:middle_name],
            last_name: politician_info[:last_name],
            twitter_id: twitter_user_id,
            party_id: @party_ids[politician_info[:party]]
          })
        rescue Twitter::Error => e
          puts "Twitter user %s not found !" % twitter_user
        end
      end
    end
  end

  def inexistent_twitter_users
    new_twitter_users = []

    @politicians.keys.each do |twitter_user|
      new_twitter_users << twitter_user if Politician.where(:user_name => twitter_user).length == 0
    end

    new_twitter_users
  end
end

namespace :politicians do
  desc 'Import A CSV file'
  task :import => :environment do
    require 'csv'


    import_politicians = ImportPoliticians.new
    # make separator configurable
    separator = ENV['CSV_SEP'].present? ? ENV['CSV_SEP'] : ','

    import_politicians.import_from_csv(separator)
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

    twitter_users = FactoryTwitterClient.new_client.users(usernames.keys)
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
