class AddAutoPublishToPoliticiansTable < ActiveRecord::Migration
  def change
    add_column :politicians, :auto_publish, :boolean, :default => false
  end
end
