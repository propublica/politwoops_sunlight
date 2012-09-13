class ChangeColumnOnPolAccount < ActiveRecord::Migration
  def up
    rename_column :politicians, :account_id, :account_type_id
  end

  def down
    rename_column :politicians, :account_type_id, :account_id
  end
end
