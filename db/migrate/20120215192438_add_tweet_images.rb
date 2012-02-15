class AddTweetImages < ActiveRecord::Migration
  def self.up
    create_table :tweet_images do |t|
      t.string :url
      t.integer :tweet_id

      t.timestamps
    end
    change_column :tweet_images, :tweet_id, :bigint
  end

  def self.down
    drop_table :tweet_images
  end
end