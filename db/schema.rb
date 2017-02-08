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

ActiveRecord::Schema.define(version: 20170208172750) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.text     "question"
    t.text     "text"
    t.integer  "membership_id"
    t.integer  "question_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "answers", ["created_at"], name: "index_answers_on_created_at", using: :btree
  add_index "answers", ["membership_id"], name: "index_answers_on_membership_id", using: :btree
  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "memberships", force: :cascade do |t|
    t.integer  "space_id"
    t.integer  "user_id"
    t.string   "name",              limit: 255
    t.string   "website",           limit: 255
    t.string   "messenger_type",    limit: 255
    t.string   "messenger_account", limit: 255
    t.string   "picture",           limit: 255
    t.string   "cobot_id",          limit: 255
    t.text     "bio"
    t.text     "profession"
    t.text     "industry"
    t.text     "skills"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.date     "canceled_to"
  end

  add_index "memberships", ["created_at"], name: "index_memberships_on_created_at", using: :btree
  add_index "memberships", ["space_id"], name: "index_memberships_on_space_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.text     "text"
    t.string   "question_type", limit: 255
    t.integer  "space_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "questions", ["space_id"], name: "index_questions_on_space_id", using: :btree

  create_table "spaces", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.string   "secret",              limit: 255
    t.string   "cobot_url",           limit: 255
    t.string   "cobot_id",            limit: 255
    t.string   "subdomain",           limit: 255
    t.boolean  "members_only"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "hide_default_fields"
    t.string   "webhook_secret"
    t.string   "access_token"
  end

  add_index "spaces", ["name"], name: "index_spaces_on_name", using: :btree
  add_index "spaces", ["subdomain"], name: "index_spaces_on_subdomain", using: :btree
  add_index "spaces", ["webhook_secret"], name: "index_spaces_on_webhook_secret", using: :btree

  create_table "users", force: :cascade do |t|
    t.string "cobot_id", limit: 255
    t.string "email",    limit: 255
    t.jsonb  "admin_of",             default: {}
  end

  add_index "users", ["cobot_id"], name: "index_users_on_cobot_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree

end
