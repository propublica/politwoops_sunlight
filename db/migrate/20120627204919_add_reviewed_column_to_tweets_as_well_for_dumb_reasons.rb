# doing this so that the tweets and deleted tweets tables have the same columns, for ease
# of dealing with two nearly identical tables in SQL and in ORM inheritance

class AddReviewedColumnToTweetsAsWellForDumbReasons < ActiveRecord::Migration
  def self.up
  	add_column :tweets, :reviewed, :boolean, :default => false
  	add_index :tweets, :reviewed
  end

  def self.down
  	remove_index :tweets, :reviewed
  	remove_column :tweets, :reviewed
  end
end
