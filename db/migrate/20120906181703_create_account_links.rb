class CreateAccountLinks < ActiveRecord::Migration
  def change
    create_table :account_links do |t|
      t.integer :politician_id
      t.integer :link_id

      t.timestamps
    end
  end
end
