class ChangeColumnOnAccountType < ActiveRecord::Migration
  def up
    rename_column :account_types, :type, :name 
  end

  def down
    rename_column :account_types, :name, :type
  end
end
