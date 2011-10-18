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

ActiveRecord::Schema.define(:version => 20111018204851) do

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "full_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "language",   :limit => 12, :default => "en"
    t.boolean  "hide",                     :default => false
    t.text     "sponsor"
  end

  add_index "groups", ["name"], :name => "index_groups_on_name"

  create_table "groups_politicians", :id => false, :force => true do |t|
    t.integer "politician_id"
    t.integer "group_id"
  end

  add_index "groups_politicians", ["politician_id", "group_id"], :name => "index_groups_politicians_on_politician_id_and_group_id"

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parties", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "politicians", :force => true do |t|
    t.string  "user_name",  :limit => 64,                :null => false
    t.integer "twitter_id",                              :null => false
    t.integer "party_id"
    t.integer "status",                   :default => 1
  end

  add_index "politicians", ["status"], :name => "index_politicians_on_status"
  add_index "politicians", ["user_name"], :name => "user_name"

  create_table "statistics", :force => true do |t|
    t.string   "what"
    t.date     "when"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tweets", :force => true do |t|
    t.string   "user_name",     :limit => 64
    t.string   "content"
    t.boolean  "deleted",                     :default => false, :null => false
    t.datetime "created",                                        :null => false
    t.datetime "modified",                                       :null => false
    t.text     "tweet"
    t.integer  "politician_id"
  end

  add_index "tweets", ["created"], :name => "created"
  add_index "tweets", ["deleted"], :name => "deleted"
  add_index "tweets", ["modified"], :name => "modified"
  add_index "tweets", ["politician_id"], :name => "index_tweets_on_politician_id"
  add_index "tweets", ["user_name"], :name => "user_name"

  create_table "users", :force => true do |t|
    t.string   "login",                              :null => false
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.integer  "is_admin"
  end

end
