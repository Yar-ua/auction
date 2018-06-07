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

ActiveRecord::Schema.define(version: 20180607132357) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bids", force: :cascade do |t|
    t.bigint "lot_id"
    t.bigint "user_id"
    t.float "proposed_price", null: false
    t.boolean "is_winner", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_winner"], name: "index_bids_on_is_winner"
    t.index ["lot_id"], name: "index_bids_on_lot_id"
    t.index ["proposed_price"], name: "index_bids_on_proposed_price"
    t.index ["user_id"], name: "index_bids_on_user_id"
  end

  create_table "lots", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title"
    t.string "description", default: ""
    t.float "current_price", null: false
    t.float "estimated_price", null: false
    t.datetime "lot_start_time", null: false
    t.datetime "lot_end_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.string "image"
    t.index ["lot_end_time"], name: "index_lots_on_lot_end_time"
    t.index ["lot_start_time"], name: "index_lots_on_lot_start_time"
    t.index ["user_id"], name: "index_lots_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "email"
    t.string "phone"
    t.string "first_name"
    t.string "last_name"
    t.string "birth_day"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "bids", "lots"
  add_foreign_key "bids", "users"
  add_foreign_key "lots", "users"
end
