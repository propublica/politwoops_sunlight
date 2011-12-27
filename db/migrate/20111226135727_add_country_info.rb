class AddCountryInfo < ActiveRecord::Migration
  def self.up
    add_column :groups, :flag, :string
    add_column :groups, :is_domain, :boolean
    add_index :groups, :flag
    add_index :groups, :is_domain
  end

  def self.down
    remove_index :groups, :is_domain
    remove_index :groups, :flag
    remove_column :groups, :is_domain
    remove_column :groups, :flag
  end
end