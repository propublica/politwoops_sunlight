namespace :cache do
  desc 'Clear the Rails cache'
  task :clear => :environment do
    Rails.cache.clear
    "OK"
  end
end

