class AddIsAdminToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :is_admin, :int
  end

  def self.down
    remove_column :users, :is_admin
  end
end
