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

ActiveRecord::Schema.define(version: 2021_03_28_090741) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assigns", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_assigns_on_team_id"
    t.index ["user_id"], name: "index_assigns_on_user_id"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_bookmarks_on_report_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "comment", null: false
    t.bigint "report_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_comments_on_report_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_date"
    t.string "author"
    t.datetime "accrual_date"
    t.string "site_of_occurrence"
    t.text "trouble_content"
    t.text "first_aid"
    t.text "interim_measures"
    t.text "permanent_measures"
    t.text "confirmation_of_effectiveness"
    t.boolean "checkbox_first"
    t.boolean "checkbox_interim"
    t.boolean "checkbox_final"
    t.bigint "user_id", null: false
    t.bigint "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "confirmed_date"
    t.integer "search_item", default: 0
    t.index ["team_id"], name: "index_reports_on_team_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "tag_maps", force: :cascade do |t|
    t.bigint "report_id"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_tag_maps_on_report_id"
    t.index ["tag_id"], name: "index_tag_maps_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "tag_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "icon"
    t.text "remark"
    t.bigint "owner_id"
    t.bigint "charge_in_person_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["charge_in_person_id"], name: "index_teams_on_charge_in_person_id"
    t.index ["owner_id"], name: "index_teams_on_owner_id"
    t.index ["user_id"], name: "index_teams_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "remark"
    t.string "icon"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "assigns", "teams"
  add_foreign_key "assigns", "users"
  add_foreign_key "bookmarks", "reports"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "comments", "reports"
  add_foreign_key "comments", "users"
  add_foreign_key "reports", "teams"
  add_foreign_key "reports", "users"
  add_foreign_key "tag_maps", "reports"
  add_foreign_key "tag_maps", "tags"
  add_foreign_key "teams", "users"
end
