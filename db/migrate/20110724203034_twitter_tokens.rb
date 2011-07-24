class TwitterTokens < ActiveRecord::Migration
  def self.up
    add_column :groups, :consumer_key, :string
    add_column :groups, :consumer_secret, :string
    add_column :groups, :oauth_token, :string
    add_column :groups, :oauth_secret, :string
  end

  def self.down
    remove_column :groups, :consumer_key
    remove_column :groups, :consumer_secret
    remove_column :groups, :oauth_token
    remove_column :groups, :oauth_secret
  end
end