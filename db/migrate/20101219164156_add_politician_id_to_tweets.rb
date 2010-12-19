class AddPoliticianIdToTweets < ActiveRecord::Migration
  def self.up
    add_column :tweets, :politician_id, :int
  end

  def self.down
    remove_column :tweets, :politician_id
  end
end
