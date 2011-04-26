class AddGroupIdToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :group_id, :int
  end

  def self.down
    remove_column :users, :group_id
  end
end
