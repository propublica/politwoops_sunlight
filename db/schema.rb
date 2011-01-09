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

ActiveRecord::Schema.define(:version => 20110109223854) do

  create_table "parties", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "politicians", :force => true do |t|
    t.string  "user_name",  :limit => 64, :null => false
    t.integer "twitter_id",               :null => false
    t.integer "party_id"
  end

  add_index "politicians", ["user_name"], :name => "user_name"

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
  add_index "tweets", ["user_name"], :name => "user_name"

end
