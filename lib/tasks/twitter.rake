namespace :twitter do
  desc 'Import a Twitter list'
  task :sync_list => :environment do
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
        if p.valid? && p.save
          puts "* " + user.screen_name
          politician_id = p.id
        else
          puts "  " + user.screen_name
          politician_id = Politician.where(:user_name => user.screen_name).first.id
        end
        params[:politician_ids] << politician_id
      end
      next_cursor = m.next_cursor
    end
    # empty the group from politicians
    empty_params = {
      :politician_ids => []
    }
    g = Group.find(ENV['GROUP_ID'])
    g.update_attributes(empty_params)
    # and add them back again
    g.update_attributes(params)
  end
end