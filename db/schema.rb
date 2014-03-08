# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140306205157) do

  create_table "account_links", :force => true do |t|
    t.integer  "politician_id"
    t.integer  "link_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "account_types", :force => true do |t|
    t.string "name"
  end

  create_table "deleted_tweets", :force => true do |t|
    t.string   "user_name",           :limit => 64
    t.string   "content"
    t.boolean  "deleted",                           :default => false, :null => false
    t.datetime "created",                                              :null => false
    t.datetime "modified",                                             :null => false
    t.text     "tweet"
    t.integer  "politician_id"
    t.boolean  "approved"
    t.boolean  "reviewed"
    t.datetime "reviewed_at"
    t.text     "review_message"
    t.integer  "retweeted_id",        :limit => 8
    t.string   "retweeted_content"
    t.string   "retweeted_user_name"
    t.boolean  "is_hit",                            :default => false
  end

  add_index "deleted_tweets", ["approved"], :name => "index_deleted_tweets_on_approved"
  add_index "deleted_tweets", ["content"], :name => "index_tweets_on_content"
  add_index "deleted_tweets", ["created"], :name => "created"
  add_index "deleted_tweets", ["deleted"], :name => "deleted"
  add_index "deleted_tweets", ["modified"], :name => "index_deleted_tweets_on_modified"
  add_index "deleted_tweets", ["modified"], :name => "modified"
  add_index "deleted_tweets", ["politician_id", "created"], :name => "index_deleted_tweets_on_politician_id_and_created"
  add_index "deleted_tweets", ["politician_id", "modified"], :name => "index_deleted_tweets_on_politician_id_and_modified"
  add_index "deleted_tweets", ["politician_id"], :name => "index_tweets_on_politician_id"
  add_index "deleted_tweets", ["reviewed"], :name => "index_deleted_tweets_on_reviewed"
  add_index "deleted_tweets", ["user_name"], :name => "user_name"

  create_table "offices", :force => true do |t|
    t.string "title",        :null => false
    t.string "abbreviation", :null => false
  end

  create_table "parties", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "display_name"
  end

  create_table "politicians", :force => true do |t|
    t.string   "user_name",           :limit => 64,                :null => false
    t.integer  "twitter_id",                                       :null => false
    t.integer  "party_id"
    t.integer  "status",                            :default => 1
    t.string   "profile_image_url"
    t.string   "state"
    t.integer  "account_type_id"
    t.integer  "office_id"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "suffix"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "politicians", ["status"], :name => "index_politicians_on_status"
  add_index "politicians", ["user_name"], :name => "user_name"

  create_table "tweet_images", :force => true do |t|
    t.string   "url"
    t.integer  "tweet_id",   :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tweet_images", ["tweet_id"], :name => "index_tweet_images_on_tweet_id"

  create_table "tweets", :force => true do |t|
    t.string   "user_name",           :limit => 64
    t.string   "content"
    t.boolean  "deleted",                           :default => false, :null => false
    t.datetime "created",                                              :null => false
    t.datetime "modified",                                             :null => false
    t.text     "tweet"
    t.integer  "politician_id"
    t.boolean  "approved",                          :default => false
    t.boolean  "reviewed",                          :default => false
    t.datetime "reviewed_at"
    t.text     "review_message"
    t.integer  "retweeted_id",        :limit => 8
    t.string   "retweeted_content"
    t.string   "retweeted_user_name"
    t.boolean  "is_hit",                            :default => false
  end

  add_index "tweets", ["approved"], :name => "index_tweets_on_approved"
  add_index "tweets", ["content"], :name => "index_tweets_on_content"
  add_index "tweets", ["created"], :name => "created"
  add_index "tweets", ["deleted"], :name => "deleted"
  add_index "tweets", ["modified"], :name => "index_tweets_on_modified"
  add_index "tweets", ["modified"], :name => "modified"
  add_index "tweets", ["politician_id", "created"], :name => "index_tweets_on_politician_id_and_created"
  add_index "tweets", ["politician_id", "modified"], :name => "index_tweets_on_politician_id_and_modified"
  add_index "tweets", ["politician_id"], :name => "index_tweets_on_politician_id"
  add_index "tweets", ["reviewed"], :name => "index_tweets_on_reviewed"
  add_index "tweets", ["user_name"], :name => "user_name"

end
