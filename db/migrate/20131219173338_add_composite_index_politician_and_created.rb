class AddCompositeIndexPoliticianAndCreated < ActiveRecord::Migration
  def up
    add_index :tweets, [:politician_id, :modified]
    add_index :deleted_tweets, [:politician_id, :modified]
  end

  def down
    remove_index :tweets, [:politician_id, :modified]
    remove_index :deleted_tweets, [:politician_id, :modified]
  end
end
