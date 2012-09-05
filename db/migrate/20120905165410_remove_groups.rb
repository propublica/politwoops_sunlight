class RemoveGroups < ActiveRecord::Migration
  def self.up
    drop_table :groups
    drop_table :groups_politicians
  end

  def self.down
    # whatever
  end
end
