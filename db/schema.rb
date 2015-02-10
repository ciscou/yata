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

ActiveRecord::Schema.define(version: 20150210160731) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["user_id"], name: "index_categories_on_user_id", using: :btree

  create_table "ownerships", force: true do |t|
    t.integer  "user_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ownerships", ["task_id"], name: "index_ownerships_on_task_id", using: :btree
  add_index "ownerships", ["user_id"], name: "index_ownerships_on_user_id", using: :btree

  create_table "sub_tasks", force: true do |t|
    t.integer  "task_id"
    t.string   "name"
    t.boolean  "done",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sub_tasks", ["task_id"], name: "index_sub_tasks_on_task_id", using: :btree

  create_table "tasks", force: true do |t|
    t.string   "name"
    t.datetime "due_at"
    t.boolean  "done",          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "reminder_sent", default: false
    t.integer  "reminder"
    t.string   "token"
    t.text     "description"
    t.string   "url"
    t.string   "location"
    t.string   "repeat_every"
    t.integer  "category_id"
    t.string   "image"
  end

  add_index "tasks", ["category_id"], name: "index_tasks_on_category_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
