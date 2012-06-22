class AddApprovedFlag < ActiveRecord::Migration
  def self.up
    add_column :tweets, :approved, :boolean, :default => false
    add_column :deleted_tweets, :approved, :boolean
    add_index :tweets, :approved
    add_index :deleted_tweets, :approved
  end

  def self.down
    remove_index :tweets, :approved
    remove_index :deleted_tweets, :approved
    remove_column :deleted_tweets, :approved
    remove_column :tweets, :approved
  end
end