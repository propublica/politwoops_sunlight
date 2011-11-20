class AddIndexToContent < ActiveRecord::Migration
  def self.up
    add_index :tweets, :content
  end

  def self.down
    remove_index :tweets, :content
  end
end