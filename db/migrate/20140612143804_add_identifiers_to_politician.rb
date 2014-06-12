class AddIdentifiersToPolitician < ActiveRecord::Migration
  def change
    add_column :politicians, :bioguide_id, :string, :limit => 7
    add_column :politicians, :opencivicdata_id, :text
  end
end
