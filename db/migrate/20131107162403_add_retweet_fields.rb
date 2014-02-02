class AddRetweetFields < ActiveRecord::Migration
  def change
    # Integer with byte-size 8 should equate to "big integer" in mysql

    add_column :tweets, :retweeted_id, :integer, { :limit => 8 }
    add_column :tweets, :retweeted_content, :string
    add_column :tweets, :retweeted_user_name, :string

    add_column :deleted_tweets, :retweeted_id, :integer, { :limit => 8 }
    add_column :deleted_tweets, :retweeted_content, :string
    add_column :deleted_tweets, :retweeted_user_name, :string
  end
end
