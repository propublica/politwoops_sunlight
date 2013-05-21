class AddShortUrlToDeletedTweet < ActiveRecord::Migration
  def change
    add_column :deleted_tweets, :short_url, :string
  end
end
