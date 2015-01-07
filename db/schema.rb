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

ActiveRecord::Schema.define(version: 20150107223332) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_formatters", force: :cascade do |t|
    t.integer  "start"
    t.integer  "end"
    t.integer  "total"
    t.integer  "num_pages"
    t.integer  "page"
    t.integer  "page_size"
    t.string   "uri"
    t.string   "first_page_uri"
    t.string   "last_page_uri"
    t.string   "previous_page_uri"
    t.string   "next_page_uri"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.json     "data"
  end

  create_table "headers", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "data_type"
    t.integer  "version_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "service_tags", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", force: :cascade do |t|
    t.integer  "organization_id",                 null: false
    t.string   "description"
    t.string   "name",                            null: false
    t.string   "slug",                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "license",         default: "MIT"
    t.boolean  "activated",       default: true
    t.integer  "creator_id"
  end

  add_index "services", ["organization_id"], name: "index_services_on_organization_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "organization_id"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "version_updates", force: :cascade do |t|
    t.integer  "version_id"
    t.integer  "user_id"
    t.string   "filename"
    t.integer  "status",     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", force: :cascade do |t|
    t.integer  "number",        default: 1
    t.integer  "service_id"
    t.boolean  "active",        default: true
    t.integer  "total_records", default: 0,    null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

end
