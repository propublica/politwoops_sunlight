# TODO change this to reviewed_at

class AddReviewedAtAndReviewMessageToTweets < ActiveRecord::Migration
  def self.up
    add_column :tweets, :reviewed_at, :timestamp
    add_column :deleted_tweets, :reviewed_at, :timestamp
    add_column :tweets, :review_message, :text
    add_column :deleted_tweets, :review_message, :text
  end

  def self.down
    remove_column :deleted_tweets, :reviewed_at
    remove_column :tweets, :reviewed_at
    remove_column :deleted_tweets, :review_message
    remove_column :tweets, :review_message
  end
end