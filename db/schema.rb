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

ActiveRecord::Schema.define(version: 2019_03_01_202304) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "discord_identities", force: :cascade do |t|
    t.string "uid"
    t.string "name"
    t.string "email"
    t.string "image_url"
    t.string "token"
    t.string "refresh_token"
    t.datetime "expires_at"
    t.boolean "expires"
    t.string "username"
    t.string "discriminator"
    t.boolean "mfa_enabled"
    t.string "extra_id"
    t.string "avatar"
    t.bigint "user_id"
    t.boolean "bot", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_discord_identities_on_uid"
    t.index ["user_id"], name: "index_discord_identities_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "discord_identities", "users"
end
