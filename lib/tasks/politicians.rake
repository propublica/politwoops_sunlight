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

  # task :reset => :environment do
  #   group = Group.find 3
  #   group.politician_ids = Politician.all.map {|p| p.id}
  #   group.save!
  # end
end
