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

ActiveRecord::Schema.define(:version => 20091129152625) do

  create_table "records", :force => true do |t|
    t.datetime "time"
    t.datetime "target_time"
    t.text     "content"
    t.integer  "user_id"
    t.boolean  "success",     :default => true
    t.boolean  "pri",         :default => false
    t.boolean  "status",      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", :force => true do |t|
    t.integer  "user_id"
    t.integer  "state",          :default => 0
    t.integer  "continuous_num", :default => 0
    t.integer  "num",            :default => 0
    t.integer  "score",          :default => 0
    t.datetime "average"
    t.float    "success_rate",   :default => 0.0
    t.datetime "last_record_at"
  end

  create_table "users", :force => true do |t|
    t.string   "fb_id"
    t.datetime "target_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "timezone",    :default => "Taipei"
    t.string   "name"
    t.string   "image"
  end

end
