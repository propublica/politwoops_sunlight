namespace :twitter do
  desc 'Import a Twitter list'
  task :import_list => :environment do
    puts "Getting lists for:"
    puts ENV['TWITTER_USER']
    puts ENV['TWITTER_LIST']
    next_cursor = -1
    until next_cursor == 0
      m = Twitter.list_members(ENV['TWITTER_USER'], ENV['TWITTER_LIST'], :cursor => next_cursor)
      m.users.each do |user|
        p = Politician.new({
          :user_name => user.screen_name,
          :twitter_id => user.id,
          :party_id => ENV['PARTY_ID']
        })
        if p.save
          puts "* " + user.screen_name
        else
          puts "  " + user.screen_name
        end
      end
      next_cursor = m.next_cursor
    end
  end
end