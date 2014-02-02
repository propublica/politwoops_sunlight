class AddCompositeIndexesForPoliticanJoins < ActiveRecord::Migration
  def up
    add_index :tweets, [:politician_id, :created]
    add_index :deleted_tweets, [:politician_id, :created]
  end

  def down
    remove_index :tweets, [:politician_id, :created]
    remove_index :deleted_tweets, [:politician_id, :created]
  end
end
