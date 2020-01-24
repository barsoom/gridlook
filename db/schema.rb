# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_24_154645) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
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
    t.string "user_identifier"
    t.string "associated_records", default: [], null: false, array: true
    t.index ["associated_records"], name: "index_events_on_associated_records", using: :gin
    t.index ["email"], name: "index_events_on_email"
    t.index ["happened_at", "id"], name: "index_events_on_happened_at_and_id"
    t.index ["mailer_action", "happened_at", "id"], name: "index_events_on_mailer_action_and_happened_at_and_id"
    t.index ["user_identifier"], name: "index_events_on_user_identifier"
  end

  create_table "events_data", force: :cascade do |t|
    t.integer "total_events"
  end

end
