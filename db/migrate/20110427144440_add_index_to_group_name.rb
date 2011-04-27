class AddIndexToGroupName < ActiveRecord::Migration
  def self.up
    add_index :groups, [:name]
  end

  def self.down
  end
end
