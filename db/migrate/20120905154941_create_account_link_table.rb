class CreateAccountLinkTable < ActiveRecord::Migration
  def self.up
    create_table :account_links do |t|
       t.integer :politician_id
       t.integer :linked_id
    end
  end

  def self.down
    drop_table :account_links
  end
end
