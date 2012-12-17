class AddTweetImageTweetIdIndex < ActiveRecord::Migration
  def up
      add_index :tweet_images, :tweet_id
  end

  def down
      remove_index :tweet_images, :tweet_id
  end
end
