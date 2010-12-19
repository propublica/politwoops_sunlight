class SetPoliticianIdOfTweets < ActiveRecord::Migration
  def self.up
    execute "UPDATE tweets t LEFT JOIN politicians p on t.user_name = p.user_name SET t.politician_id = p.id;"
  end

  def self.down
    execute "UPDATE tweets SET politician_id = NULL;"
  end
end
