# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_09_18_071433) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "issue_routines", force: :cascade do |t|
    t.bigint "sleep_issue_id", null: false
    t.bigint "routine_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["routine_id"], name: "index_issue_routines_on_routine_id"
    t.index ["sleep_issue_id"], name: "index_issue_routines_on_sleep_issue_id"
  end

  create_table "routines", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "recommend_time"
    t.string "line_text"
  end

  create_table "sleep_issues", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "issue_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sleep_issues_on_user_id"
  end

  create_table "sleep_records", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "routine_id"
    t.date "record_date", null: false
    t.integer "morning_condition"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.time "wake_up_time"
    t.index ["routine_id"], name: "index_sleep_records_on_routine_id"
    t.index ["user_id"], name: "index_sleep_records_on_user_id"
  end

  create_table "user_routines", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "routine_id", null: false
    t.date "choose_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["routine_id"], name: "index_user_routines_on_routine_id"
    t.index ["user_id"], name: "index_user_routines_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.time "notification_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "line_user_id", null: false
    t.time "bedtime"
  end

  add_foreign_key "issue_routines", "routines"
  add_foreign_key "issue_routines", "sleep_issues"
  add_foreign_key "sleep_issues", "users"
  add_foreign_key "sleep_records", "routines"
  add_foreign_key "sleep_records", "users"
  add_foreign_key "user_routines", "routines"
  add_foreign_key "user_routines", "users"
end
