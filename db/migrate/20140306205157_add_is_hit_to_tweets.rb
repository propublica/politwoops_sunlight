class AddIsHitToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :is_hit, :boolean, default: false
  end
end
