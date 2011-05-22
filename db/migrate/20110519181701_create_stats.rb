class CreateStats < ActiveRecord::Migration
  def self.up
    create_table :statistics do |t|
      t.string :what
      t.date :when
      t.integer :amount

      t.timestamps
    end
  end

  def self.down
    drop_table :statistics
  end
end
