class RenameOfficeTableToOffices < ActiveRecord::Migration
  def self.up
    rename_table :office_held, :offices
  end

  def self.down
    rename_table :offices, :office_held
  end
end
