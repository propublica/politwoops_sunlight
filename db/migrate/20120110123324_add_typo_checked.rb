class AddTypoChecked < ActiveRecord::Migration
  def self.up
    add_column :tweets, :typo_checked, :boolean, :default => false
    add_column :deleted_tweets, :typo_checked, :boolean
    add_index :tweets, :typo_checked
    add_index :deleted_tweets, :typo_checked
  end

  def self.down
    remove_index :tweets, :typo_checked
    remove_index :deleted_tweets, :typo_checked
    remove_column :deleted_tweets, :typo_checked
    remove_column :tweets, :typo_checked
  end
end