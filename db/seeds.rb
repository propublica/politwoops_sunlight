# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

admins = {"admin" => {:pass => "pass", :mail => "admin@politwoops.com"}}
admins.each do |username, val|
  admin = Admin::Administrator.find_or_initialize_by_username(username)
  admin.password = val[:pass]
  admin.password_confirmation = val[:pass]
  admin.email = val[:mail]
  admin.save!
end