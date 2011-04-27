class AddIndexToPoliticianId < ActiveRecord::Migration
  def self.up
    add_index :tweets, [:politician_id]
  end

  def self.down
  end
end
