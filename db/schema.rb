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

ActiveRecord::Schema[7.1].define(version: 2025_04_04_030736) do
  create_table "twitch_streamers", force: :cascade do |t|
    t.string "username"
    t.string "twitch_id"
    t.string "profile_image_url"
    t.boolean "live"
    t.integer "viewers"
    t.integer "followers"
    t.string "current_game"
    t.datetime "last_stream_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "viewer_snapshots", force: :cascade do |t|
    t.string "streamable_type", null: false
    t.integer "streamable_id", null: false
    t.integer "viewer_count"
    t.datetime "captured_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["streamable_type", "streamable_id"], name: "index_viewer_snapshots_on_streamable"
  end

  create_table "youtube_streamers", force: :cascade do |t|
    t.string "channel_name"
    t.string "channel_id"
    t.integer "subscribers"
    t.boolean "live"
    t.integer "viewers"
    t.datetime "last_stream_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
