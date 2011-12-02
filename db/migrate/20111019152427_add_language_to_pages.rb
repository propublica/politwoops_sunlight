class AddLanguageToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :language, :string
    add_index :pages, :language
  end

  def self.down
    remove_index :pages, :language
    remove_column :pages, :language
  end
end