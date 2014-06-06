namespace :tweets do
  desc 'Requeue a tweet from the source JSON'
  task :requeue => :environment do
    tweet_id = ENV['tweet'] || ENV['TWEET']
    if tweet_id.blank?
      return puts 'Expected tweet= argument'
    end

    queue_name = Settings.fetch(:beanstalk_queues, {})[:tweets]
    if queue_name.blank?
      return puts 'Expected :beantalk_queues[:tweets] setting.'
    end

    tweet = Tweet.find(tweet_id)
    result = RequeueTweet.call(:tweet => tweet, :queue_name => queue_name)
    puts result.to_s
  end

  desc 'Export fixtures for minimal model graph focused on a given tweet.'
  task :export_fixtures => :environment do
    tweet_id = ENV['tweet'] || ENV['TWEET']
    if tweet_id.blank?
      return puts 'Expected tweet= argument'
    end

    tweet = Tweet.find(tweet_id)
    dirpath = File.join(ENV['TMP'] || '/tmp', tweet.id.to_s)
    FileUtils.mkdir_p(dirpath)
    result = Export::ExportTweetSubgraphFixtures.call(:tweet => tweet, :export_dir => dirpath)
    puts result.to_s
  end
end

