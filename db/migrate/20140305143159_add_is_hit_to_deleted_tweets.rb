class AddIsHitToDeletedTweets < ActiveRecord::Migration
  def change
    add_column :deleted_tweets, :is_hit, :boolean, default: false
  end
end
