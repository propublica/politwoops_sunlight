# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Group.create!(
  :name => "Main",
  :language => "en",
  :full_name => "Main group that everyone is in by default",
  :hide => true,
  :politician_ids => []
)