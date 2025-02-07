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

ActiveRecord::Schema.define(:version => 20120625171153) do

  create_table "caches", :force => true do |t|
    t.string   "url"
    t.integer  "frequency"
    t.text     "store"
    t.datetime "last_cached"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "caches", ["url"], :name => "url_index"

  create_table "feeds", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "cache_frequency", :default => 30
    t.text     "description"
    t.boolean  "show_title",      :default => true
  end

  create_table "service_feed_bridges", :force => true do |t|
    t.integer  "service_id"
    t.integer  "feed_id"
    t.integer  "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "service_feed_bridges", ["feed_id"], :name => "index_service_feed_bridges_on_feed_id"
  add_index "service_feed_bridges", ["service_id"], :name => "index_service_feed_bridges_on_service_id"

  create_table "services", :force => true do |t|
    t.string   "name"
    t.string   "service_slug"
    t.integer  "cache_frequency"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.text     "css_style"
    t.boolean  "transform_course_code", :default => false
    t.boolean  "live",                  :default => false
    t.integer  "show_max_entries",      :default => 5
  end

  create_table "tagged_urls", :force => true do |t|
    t.string   "tag"
    t.string   "url"
    t.string   "title"
    t.text     "desc"
    t.string   "source"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
