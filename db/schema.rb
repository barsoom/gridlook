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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140825062349) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.text     "category"
    t.text     "data"
    t.datetime "happened_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "unique_args"
    t.string   "mailer_action"
  end

  add_index "events", ["email"], name: "index_events_on_email", using: :btree
  add_index "events", ["happened_at", "id"], name: "index_events_on_happened_at_and_id", using: :btree
  add_index "events", ["mailer_action", "happened_at", "id"], name: "index_events_on_mailer_action_and_happened_at_and_id", using: :btree
  add_index "events", ["name"], name: "index_events_on_name", using: :btree

  create_table "events_data", force: true do |t|
    t.integer "total_events"
  end

end
