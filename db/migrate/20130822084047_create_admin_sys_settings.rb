class CreateAdminSysSettings < ActiveRecord::Migration
  def change
    create_table :admin_sys_settings do |t|
      t.string :attr_key
      t.string :attr_val
      
      t.timestamps
    end
  end
end
