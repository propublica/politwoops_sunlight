class AddDeletedTweetsTable < ActiveRecord::Migration
  def self.up
    execute "CREATE TABLE `deleted_tweets` LIKE `tweets`"
    execute "INSERT INTO `deleted_tweets` SELECT * FROM `tweets` WHERE `deleted` = 1 AND content IS NOT NULL"
  end

  def self.down
    drop_table :deleted_tweets
  end
end
