class AddProfileImageUrlToPoliticians < ActiveRecord::Migration
  def self.up
  	add_column :politicians, :profile_image_url, :string
  end

  def self.down
  	remove_column :politicians, :profile_image_url
  end
end