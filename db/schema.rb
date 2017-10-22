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

ActiveRecord::Schema.define(version: 20171127144053) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.datetime "published_at"
  end

  create_table "bars", id: :serial, force: :cascade do |t|
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "foo"
    t.text "baz"
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.string "commentable_type"
    t.integer "commentable_id"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
  end

  create_table "hupu_news", id: :serial, force: :cascade do |t|
    t.json "json"
    t.json "box"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jiandan_comments", id: :serial, force: :cascade do |t|
    t.jsonb "json"
    t.jsonb "box"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nba_games", force: :cascade do |t|
    t.string "season_year"
    t.string "season_type"
    t.date "date"
    t.string "road"
    t.string "home"
    t.integer "road_score"
    t.integer "home_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pictures", id: :serial, force: :cascade do |t|
    t.string "filename"
    t.string "pid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "positions", id: :serial, force: :cascade do |t|
    t.jsonb "json"
    t.jsonb "box"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "repos", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "tag_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_repos_on_name"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.integer "repo_id"
    t.string "name"
    t.string "git_url"
    t.string "git_commit"
    t.string "dockerfile_dir"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "dockerfile_content"
    t.datetime "dockerfile_downloaded_at"
    t.index ["repo_id"], name: "index_tags_on_repo_id"
  end

  create_table "taobao_items", force: :cascade do |t|
    t.string "item_no"
    t.string "cover"
    t.string "title"
    t.string "description"
    t.jsonb "json"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_no"], name: "index_taobao_items_on_item_no"
  end

  create_table "taobao_reviews", force: :cascade do |t|
    t.string "item_no"
    t.string "review_no"
    t.string "parent_no"
    t.jsonb "json"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_no"], name: "index_taobao_reviews_on_item_no"
    t.index ["parent_no"], name: "index_taobao_reviews_on_parent_no"
    t.index ["review_no"], name: "index_taobao_reviews_on_review_no"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "auth_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "tags", "repos"
end
