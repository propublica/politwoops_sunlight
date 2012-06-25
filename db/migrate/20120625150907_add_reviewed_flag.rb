class AddReviewedFlag < ActiveRecord::Migration
  def self.up
    add_column :deleted_tweets, :reviewed, :boolean
    add_index :deleted_tweets, :reviewed
  end

  def self.down
    remove_index :deleted_tweets, :reviewed
    remove_column :deleted_tweets, :reviewed
  end
end