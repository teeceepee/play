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

ActiveRecord::Schema.define(version: 20160227142128) do

  create_table "repos", force: :cascade do |t|
    t.string   "name"
    t.integer  "tag_count",  default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "repos", ["name"], name: "index_repos_on_name"

  create_table "tags", force: :cascade do |t|
    t.integer  "repo_id"
    t.string   "name"
    t.string   "git_url"
    t.string   "git_commit"
    t.string   "dockerfile_dir"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "dockerfile_content"
    t.datetime "dockerfile_downloaded_at"
  end

  add_index "tags", ["repo_id"], name: "index_tags_on_repo_id"

end
