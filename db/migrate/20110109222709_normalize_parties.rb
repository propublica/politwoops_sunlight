class NormalizeParties < ActiveRecord::Migration
  def self.up
    execute "INSERT INTO parties (name, created_at, updated_at) SELECT DISTINCT(party), NOW(), NOW() FROM politicians;"
  end

  def self.down
    execute "TRUNCATE parties;"
  end
end
