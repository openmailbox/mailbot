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

ActiveRecord::Schema.define(version: 2018_11_14_222255) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "channel_memberships", id: :serial, force: :cascade do |t|
    t.integer "channel_id"
    t.integer "user_id"
    t.integer "points", default: 0
    t.datetime "last_message_at"
  end

  create_table "channels", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "owner_id"
  end

  create_table "communities", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "platform_id"
    t.integer "user_id"
    t.datetime "created_at"
  end

  create_table "jobs", id: :serial, force: :cascade do |t|
    t.string "type"
    t.integer "frequency"
    t.datetime "last_run_at"
    t.text "details"
    t.index ["last_run_at"], name: "index_jobs_on_last_run_at"
  end

  create_table "lurk_lists", id: :serial, force: :cascade do |t|
    t.string "nickname"
    t.string "discord_channel_id"
    t.string "guild_id"
    t.text "twitch_names"
    t.integer "mailbot_rails_id"
    t.string "discord_message_id"
    t.index ["mailbot_rails_id"], name: "index_lurk_lists_on_mailbot_rails_id", unique: true
  end

  create_table "news_feed_subscriptions", id: :serial, force: :cascade do |t|
    t.integer "news_feed_id"
    t.string "discord_channel_id"
    t.string "guild_id"
    t.boolean "enabled", default: true
    t.index ["guild_id"], name: "index_news_feed_subscriptions_on_guild_id"
    t.index ["news_feed_id"], name: "index_news_feed_subscriptions_on_news_feed_id"
  end

  create_table "news_feeds", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "link"
    t.string "decription"
    t.string "reader_class"
    t.datetime "last_build_at"
    t.index ["link"], name: "index_news_feeds_on_link"
  end

  create_table "platforms", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "rss_items", id: :serial, force: :cascade do |t|
    t.string "guid"
    t.string "title"
    t.datetime "published_at"
    t.string "link"
    t.string "description"
    t.integer "news_feed_id"
    t.index ["guid"], name: "index_rss_items_on_guid"
    t.index ["news_feed_id"], name: "index_rss_items_on_news_feed_id"
  end

  create_table "rust_servers", id: :serial, force: :cascade do |t|
    t.string "ip"
    t.integer "port"
    t.integer "rcon_port"
    t.string "rcon_password"
    t.integer "community_id"
    t.integer "channel_id"
    t.datetime "last_supply_at"
    t.datetime "last_heli_at"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
  end

end
