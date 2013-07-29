class CreateAdminAdministrators < ActiveRecord::Migration
  def change
    create_table :admin_administrators do |t|
      t.string :email
      t.string :username
      t.string :crypted_password
      t.string :password_salt

      t.timestamps
    end
  end
end
