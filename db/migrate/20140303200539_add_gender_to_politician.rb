class AddGenderToPolitician < ActiveRecord::Migration
  def change
    change_table :politicians do |t|
      t.column :gender, :string, :length => 1, :default => 'U'
    end
  end
end
