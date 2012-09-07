class ChangeColumnsOnPoliticians < ActiveRecord::Migration
  def up
    rename_column :politicians, :office, :office_id
    rename_column :politicians, :account, :account_id
  end

  def down
    rename_column :politicians, :office_id, :office
    rename_column :politicians, :account_id, :account
  end
end
