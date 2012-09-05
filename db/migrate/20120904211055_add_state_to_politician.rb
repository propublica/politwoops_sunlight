class AddStateToPolitician < ActiveRecord::Migration
  def self.up
    add_column :politicians, :state, :string
    add_column :politicians, :account, :int 
    add_column :politicians, :office, :int
  end

  def self.down
    remove_column :politicians, :state
    remove_column :politicians, :account
    remove_column :politicians, :office 
  end
end
