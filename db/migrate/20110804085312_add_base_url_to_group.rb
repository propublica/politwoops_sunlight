class AddBaseUrlToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :base_url, :string, :default => 'http://www.politwoops.nl', :comment => 'Without slash at the end'
  end

  def self.down
    remove_column :groups, :base_url
  end
end