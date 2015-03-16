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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150316111003) do

  create_table "answers", :force => true do |t|
    t.text     "question"
    t.text     "text"
    t.integer  "membership_id"
    t.integer  "question_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "answers", ["created_at"], :name => "index_answers_on_created_at"
  add_index "answers", ["membership_id"], :name => "index_answers_on_membership_id"
  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"

  create_table "memberships", :force => true do |t|
    t.integer  "space_id"
    t.integer  "user_id"
    t.string   "name"
    t.string   "website"
    t.string   "messenger_type"
    t.string   "messenger_account"
    t.string   "picture"
    t.string   "cobot_id"
    t.text     "bio"
    t.text     "profession"
    t.text     "industry"
    t.text     "skills"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.date     "canceled_to"
  end

  add_index "memberships", ["created_at"], :name => "index_memberships_on_created_at"
  add_index "memberships", ["space_id"], :name => "index_memberships_on_space_id"
  add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id"

  create_table "message_boards", :force => true do |t|
    t.string   "name"
    t.integer  "space_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "message_boards", ["space_id"], :name => "index_message_boards_on_space_id"

  create_table "messages", :force => true do |t|
    t.text     "text"
    t.string   "author_name"
    t.integer  "author_id"
    t.integer  "space_id"
    t.integer  "message_board_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "messages", ["message_board_id"], :name => "index_messages_on_message_board_id"
  add_index "messages", ["space_id"], :name => "index_messages_on_space_id"

  create_table "questions", :force => true do |t|
    t.text     "text"
    t.string   "question_type"
    t.integer  "space_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "questions", ["space_id"], :name => "index_questions_on_space_id"

  create_table "spaces", :force => true do |t|
    t.string   "name"
    t.string   "secret"
    t.string   "cobot_url"
    t.string   "cobot_id"
    t.string   "subdomain"
    t.boolean  "members_only"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.boolean  "hide_default_fields"
  end

  add_index "spaces", ["name"], :name => "index_spaces_on_name"
  add_index "spaces", ["subdomain"], :name => "index_spaces_on_subdomain"

  create_table "users", :force => true do |t|
    t.string "cobot_id"
    t.string "email"
    t.string "access_token"
    t.text   "admin_of"
  end

  add_index "users", ["cobot_id"], :name => "index_users_on_cobot_id"
  add_index "users", ["email"], :name => "index_users_on_email"

end
