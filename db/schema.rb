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

ActiveRecord::Schema.define(:version => 20130914061638) do

  create_table "annexes", :force => true do |t|
    t.string   "title"
    t.integer  "law_id"
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ep_questions", :force => true do |t|
    t.integer "exampoint_id"
    t.integer "question_id"
    t.string  "state"
  end

  add_index "ep_questions", ["exampoint_id"], :name => "index_ep_questions_on_exampoint_id"
  add_index "ep_questions", ["question_id"], :name => "index_ep_questions_on_question_id"
  add_index "ep_questions", ["state"], :name => "index_ep_questions_on_state"

  create_table "epmenus", :force => true do |t|
    t.string   "title"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "ancestry"
    t.integer  "ancestry_depth"
    t.integer  "volumn"
  end

  add_index "epmenus", ["ancestry"], :name => "index_epmenus_on_ancestry"
  add_index "epmenus", ["ancestry_depth"], :name => "index_epmenus_on_ancestry_depth"
  add_index "epmenus", ["volumn"], :name => "index_epmenus_on_volumn"

  create_table "epmenus_exampoints", :id => false, :force => true do |t|
    t.integer "epmenu_id"
    t.integer "exampoint_id"
  end

  add_index "epmenus_exampoints", ["epmenu_id"], :name => "index_epmenus_exampoints_on_epmenu_id"
  add_index "epmenus_exampoints", ["exampoint_id"], :name => "index_epmenus_exampoints_on_exampoint_id"

  create_table "exampoints", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "exampoints_freelaws", :id => false, :force => true do |t|
    t.integer "exampoint_id"
    t.integer "freelaw_id"
  end

  add_index "exampoints_freelaws", ["exampoint_id"], :name => "index_exampoints_freelaws_on_exampoint_id"
  add_index "exampoints_freelaws", ["freelaw_id"], :name => "index_exampoints_freelaws_on_freelaw_id"

  create_table "exampoints_laws", :id => false, :force => true do |t|
    t.integer "exampoint_id"
    t.integer "law_id"
  end

  add_index "exampoints_laws", ["exampoint_id"], :name => "index_exampoints_laws_on_exampoint_id"
  add_index "exampoints_laws", ["law_id"], :name => "index_exampoints_laws_on_law_id"

  create_table "freelaws", :force => true do |t|
    t.text     "title"
    t.text     "content"
    t.string   "ancestry"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "state"
    t.string   "brief"
    t.string   "category"
    t.integer  "ancestry_depth", :default => 0
  end

  add_index "freelaws", ["ancestry"], :name => "index_freelaws_on_ancestry"
  add_index "freelaws", ["ancestry_depth"], :name => "index_freelaws_on_ancestry_depth"

  create_table "imports", :force => true do |t|
    t.string   "title"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "state"
  end

  add_index "imports", ["state"], :name => "index_imports_on_state"

  create_table "laws", :force => true do |t|
    t.text     "title"
    t.text     "content"
    t.string   "ancestry"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "state"
    t.string   "brief"
    t.string   "category"
    t.text     "blanks"
    t.integer  "ancestry_depth", :default => 0
  end

  add_index "laws", ["ancestry"], :name => "index_laws_on_ancestry"
  add_index "laws", ["ancestry_depth"], :name => "index_laws_on_ancestry_depth"
  add_index "laws", ["state"], :name => "index_laws_on_state"

  create_table "questions", :force => true do |t|
    t.string   "title"
    t.integer  "score"
    t.integer  "num"
    t.string   "state"
    t.text     "description"
    t.string   "answer"
    t.text     "choices"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "questions", ["num"], :name => "index_questions_on_num"

  create_table "users", :force => true do |t|
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "email",                             :null => false
    t.string   "encrypted_password", :limit => 128, :null => false
    t.string   "confirmation_token", :limit => 128
    t.string   "remember_token",     :limit => 128, :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
