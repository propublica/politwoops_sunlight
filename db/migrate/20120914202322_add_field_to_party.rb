class AddFieldToParty < ActiveRecord::Migration
  def self.up
    add_column :parties, :display_name, :string
  end

  def self.down
    remove_column :parties, :display_name
  end
end
