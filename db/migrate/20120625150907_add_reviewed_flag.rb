class AddReviewedFlag < ActiveRecord::Migration
  def self.up
    add_column :tweets, :reviewed, :boolean, :default => false
    add_column :deleted_tweets, :reviewed, :boolean
    add_index :tweets, :reviewed
    add_index :deleted_tweets, :reviewed
  end

  def self.down
    remove_index :tweets, :reviewed
    remove_index :deleted_tweets, :reviewed
    remove_column :deleted_tweets, :reviewed
    remove_column :tweets, :reviewed
  end
end