class AddPartyIdToPoliticians < ActiveRecord::Migration
  def self.up
    add_column :politicians, :party_id, :int
  end

  def self.down
    remove_column :politicians, :party_id
  end
end
