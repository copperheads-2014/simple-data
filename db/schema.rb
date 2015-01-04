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

ActiveRecord::Schema.define(version: 20150104202547) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "organizations", force: :cascade do |t|
    t.string   "name",        limit: 255
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

  create_table "service_updates", force: :cascade do |t|
    t.integer  "service_id"
    t.integer  "user_id"
    t.integer  "records_added"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", force: :cascade do |t|
    t.integer  "organization_id",                             null: false
    t.string   "description",     limit: 255
    t.string   "name",            limit: 255,                 null: false
    t.string   "slug",            limit: 255,                 null: false
    t.integer  "version",                     default: 1,     null: false
    t.integer  "total_records"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "license",         limit: 255, default: "MIT"
    t.boolean  "activated",                   default: true
    t.integer  "creator_id"
  end

  add_index "services", ["organization_id", "version"], name: "index_services_on_organization_id_and_version", using: :btree
  add_index "services", ["organization_id"], name: "index_services_on_organization_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.integer  "organization_id"
    t.string   "password_digest", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
