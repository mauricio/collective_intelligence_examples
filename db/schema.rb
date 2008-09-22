# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080919034506) do

  create_table "movies", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", :force => true do |t|
    t.integer  "user_id",                                                :default => 0, :null => false
    t.decimal  "score",                    :precision => 2, :scale => 1
    t.integer  "rated_id",                                               :default => 0, :null => false
    t.string   "rated_type", :limit => 10,                                              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["user_id"], :name => "index_ratings_on_user_id"
  add_index "ratings", ["rated_id", "user_id", "rated_type"], :name => "index_ratings_on_all"
  add_index "ratings", ["rated_id", "rated_type"], :name => "index_ratings_on_rated"

  create_table "similarities", :force => true do |t|
    t.decimal "similarity_value", :precision => 10, :scale => 8
    t.boolean "mirror",                                          :default => false
    t.integer "first_item_id",                                                      :null => false
    t.string  "first_item_type",                                                    :null => false
    t.integer "last_item_id",                                                       :null => false
    t.string  "last_item_type",                                                     :null => false
  end

  add_index "similarities", ["first_item_id", "first_item_type", "last_item_id", "last_item_type"], :name => "index_similarities_on_all_items"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
