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

ActiveRecord::Schema.define(version: 2018_05_25_194727) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.text "category"
    t.text "data"
    t.datetime "happened_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "unique_args"
    t.string "mailer_action"
    t.text "sendgrid_unique_event_id"
    t.index ["email"], name: "index_events_on_email"
    t.index ["happened_at", "id"], name: "index_events_on_happened_at_and_id"
    t.index ["mailer_action", "happened_at", "id"], name: "index_events_on_mailer_action_and_happened_at_and_id"
    t.index ["name"], name: "index_events_on_name"
    t.index ["sendgrid_unique_event_id"], name: "index_events_on_sendgrid_unique_event_id"
  end

  create_table "events_data", id: :serial, force: :cascade do |t|
    t.integer "total_events"
  end

end
