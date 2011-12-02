class GroupAddSponsor < ActiveRecord::Migration
  def self.up
    add_column :groups, :sponsor, :text
  end

  def self.down
    remove_column :groups, :sponsor
  end
end