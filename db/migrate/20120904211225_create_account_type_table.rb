class CreateAccountTypeTable < ActiveRecord::Migration
  def self.up
    create_table :account_types do |t|
        t.string :type
    end
  end

  def self.down
    drop_table :account_types
  end
end
