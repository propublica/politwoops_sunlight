class AddTweetsModifiedIndex < ActiveRecord::Migration
  def up
      add_index :tweets, :modified
      add_index :deleted_tweets, :modified
  end

  def down
      remove_index :tweets, :column => :modified
      remove_index :deleted_tweets, :column => :modified
  end
end
