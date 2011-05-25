namespace :statistics do
  desc 'Count tweets'
  task :tweets => :environment do
    # select count(*) from tweets where date(created) = DATE_ADD(CURDATE(), INTERVAL -1 DAY)
    @count = Tweet.where('DATE(created) = DATE_ADD(CURDATE(), INTERVAL -1 DAY)').count
    @statistic = Statistic.new({
      :what => 'tweets',
      :when => Date.yesterday,
      :amount => @count
    })
    @statistic.save
  end

  desc 'Count tweets'
  task :deleted_tweets => :environment do
    # select count(*) from tweets where date(created) = DATE_ADD(CURDATE(), INTERVAL -1 DAY)
    @count = Tweet.deleted.where('DATE(modified) = DATE_ADD(CURDATE(), INTERVAL -1 DAY)').count
    @statistic = Statistic.new({
      :what => 'tweets-deleted',
      :when => Date.yesterday,
      :amount => @count
    })
    @statistic.save
  end

  desc 'Count politicians (accumulated)'
  task :politicians_accumulated => :environment do
    # select count(*) from tweets where date(created) = DATE_ADD(CURDATE(), INTERVAL -1 DAY)
    @count = Politician.count
    @statistic = Statistic.new({
      :what => 'politicians',
      :when => Date.yesterday,
      :amount => @count
    })
    @statistic.save
  end
  
  #task :tweets_hours => :environment do
    # select hour(created), count(*) from tweets where created >= (DATE_ADD(NOW(), INTERVAL -1 DAY)) group by hour(created)
  #end
end