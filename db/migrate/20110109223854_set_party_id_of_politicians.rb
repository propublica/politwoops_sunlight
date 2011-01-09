class SetPartyIdOfPoliticians < ActiveRecord::Migration
  def self.up
    execute "UPDATE politicians p LEFT JOIN parties pt on p.party = pt.name SET p.party_id = pt.id;"
    remove_column :politicians, :party
  end

  def self.down
    execute "UPDATE politicians SET party_id = NULL;"
  end
end
