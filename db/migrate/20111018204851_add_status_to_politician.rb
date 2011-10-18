class AddStatusToPolitician < ActiveRecord::Migration
  def self.up
    add_column :politicians, :status, :int, :default => 1
    add_index :politicians, :status
  end

  def self.down
    remove_index :politicians, :status
    remove_column :politicians, :status
  end
end