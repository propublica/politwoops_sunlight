class StartPostDownsize < ActiveRecord::Migration

  # what the schema was when the migrations were wiped out

  def self.up
    create_table "deleted_tweets", :force => true do |t|
      t.string   "user_name",      :limit => 64
      t.string   "content"
      t.boolean  "deleted",                      :default => false, :null => false
      t.datetime "created",                                         :null => false
      t.datetime "modified",                                        :null => false
      t.text     "tweet"
      t.integer  "politician_id"
      t.boolean  "approved"
      t.boolean  "reviewed"
      t.datetime "reviewed_at"
      t.text     "review_message"
    end

    add_index "deleted_tweets", ["approved"], :name => "index_deleted_tweets_on_approved"
    add_index "deleted_tweets", ["content"], :name => "index_tweets_on_content"
    add_index "deleted_tweets", ["created"], :name => "created"
    add_index "deleted_tweets", ["deleted"], :name => "deleted"
    add_index "deleted_tweets", ["modified"], :name => "modified"
    add_index "deleted_tweets", ["politician_id"], :name => "index_tweets_on_politician_id"
    add_index "deleted_tweets", ["reviewed"], :name => "index_deleted_tweets_on_reviewed"
    add_index "deleted_tweets", ["user_name"], :name => "user_name"

    create_table "parties", :force => true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "politicians", :force => true do |t|
      t.string  "user_name",         :limit => 64,                :null => false
      t.integer "twitter_id",                                     :null => false
      t.integer "party_id"
      t.integer "status",                          :default => 1
      t.string  "profile_image_url"
    end

    add_index "politicians", ["status"], :name => "index_politicians_on_status"
    add_index "politicians", ["user_name"], :name => "user_name"

    create_table "tweet_images", :force => true do |t|
      t.string   "url"
      t.integer  "tweet_id",   :limit => 8
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "tweets", :force => true do |t|
      t.string   "user_name",      :limit => 64
      t.string   "content"
      t.boolean  "deleted",                      :default => false, :null => false
      t.datetime "created",                                         :null => false
      t.datetime "modified",                                        :null => false
      t.text     "tweet"
      t.integer  "politician_id"
      t.boolean  "approved",                     :default => false
      t.boolean  "reviewed",                     :default => false
      t.datetime "reviewed_at"
      t.text     "review_message"
    end

    add_index "tweets", ["approved"], :name => "index_tweets_on_approved"
    add_index "tweets", ["content"], :name => "index_tweets_on_content"
    add_index "tweets", ["created"], :name => "created"
    add_index "tweets", ["deleted"], :name => "deleted"
    add_index "tweets", ["modified"], :name => "modified"
    add_index "tweets", ["politician_id"], :name => "index_tweets_on_politician_id"
    add_index "tweets", ["reviewed"], :name => "index_tweets_on_reviewed"
    add_index "tweets", ["user_name"], :name => "user_name"
  end

  def self.down
    drop_table :deleted_tweets
    drop_table :tweets
    drop_table :tweet_images
    drop_table :politicians
    drop_table :parties
  end
end