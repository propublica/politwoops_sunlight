class LinkPolticiansToGroups < ActiveRecord::Migration
  def self.up
    create_table :groups_politicians, :id => false do |t|
      t.references :politician, :group
    end
  end

  def self.down
    drop_table :groups_politicians
  end
end
