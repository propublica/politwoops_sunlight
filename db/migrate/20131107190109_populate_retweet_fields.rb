class PopulateRetweetFields < ActiveRecord::Migration
  def up
    Tweet.find_each do |t|
      t.save!
    end
    DeletedTweet.find_each do |t|
      t.save!
    end
  end
end
