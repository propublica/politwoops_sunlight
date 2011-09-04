class AdminGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :hide, :boolean, :default => 0
  end

  def self.down
    remove_column :groups, :hide
  end
end