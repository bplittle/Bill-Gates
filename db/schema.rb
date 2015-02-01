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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150201205116) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: true do |t|
    t.string   "event_name"
    t.string   "date"
    t.string   "time"
    t.string   "leader_id"
    t.string   "location"
    t.string   "event_url"
    t.integer  "unit_price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "captured_status", default: false
  end

  add_index "events", ["leader_id"], name: "index_events_on_leader_id", using: :btree

  create_table "followers", force: true do |t|
    t.string   "follower_name"
    t.string   "follower_email"
    t.integer  "event_id"
    t.integer  "unit_quantity"
    t.integer  "unit_total_price"
    t.string   "stripe_token"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "followers", ["event_id"], name: "index_followers_on_event_id", using: :btree

  create_table "leaders", force: true do |t|
    t.string   "leader_name"
    t.string   "leader_email"
    t.string   "password"
    t.string   "leader_stripe_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
