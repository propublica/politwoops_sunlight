class AddLanguageToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :language, :string, :limit => 12, :default => 'en'
  end

  def self.down
    remove_column :groups, :language
  end
end