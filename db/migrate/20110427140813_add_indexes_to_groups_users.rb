class AddIndexesToGroupsUsers < ActiveRecord::Migration
  def self.up
    add_index :groups_politicians, [:politician_id, :group_id]
  end

  def self.down
    remove_index :groups_politicians, :index_groups_politicians_on_politician_id_and_group_id
  end
end
