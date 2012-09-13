class AddNameFieldsToPolitician < ActiveRecord::Migration
  def self.up
   add_column :politicians, :first_name, :string
   add_column :politicians, :middle_name, :string
   add_column :politicians, :last_name, :string
   add_column :politicians, :suffix, :string 
  end

  def self.down
   remove_column :politicians, :first_name
   remove_column :politicians, :middle_name
   remove_column :politicians, :last_name
   remove_column :politicians, :suffix
  end
end
