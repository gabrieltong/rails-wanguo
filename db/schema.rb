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

ActiveRecord::Schema.define(:version => 20131221005406) do

  create_table "annexes", :force => true do |t|
    t.string   "title"
    t.integer  "law_id"
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "books", :force => true do |t|
    t.string   "title"
    t.string   "press"
    t.float    "price"
    t.string   "author"
    t.text     "details"
    t.text     "taobao"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "published_at"
  end

  create_table "captchas", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.datetime "valid_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "state"
    t.datetime "expired_at"
    t.datetime "assigned_at"
    t.integer  "duration"
  end

  create_table "collects", :force => true do |t|
    t.integer  "collectable_id"
    t.string   "collectable_type"
    t.integer  "user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "key1_id"
    t.integer  "key2_id"
    t.integer  "key3_id"
  end

  add_index "collects", ["collectable_id"], :name => "index_collects_on_collectable_id"
  add_index "collects", ["collectable_type"], :name => "index_collects_on_collectable_type"
  add_index "collects", ["key1_id"], :name => "index_collects_on_key1_id"
  add_index "collects", ["key2_id"], :name => "index_collects_on_key2_id"
  add_index "collects", ["user_id"], :name => "index_collects_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

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
    t.string   "category"
    t.integer  "ancestry_depth", :default => 0
    t.integer  "number"
  end

  add_index "freelaws", ["ancestry"], :name => "index_freelaws_on_ancestry"
  add_index "freelaws", ["ancestry_depth"], :name => "index_freelaws_on_ancestry_depth"

  create_table "heartbeats", :force => true do |t|
    t.integer  "user_id"
    t.string   "state"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "beatable_type"
    t.integer  "beatable_id"
  end

  add_index "heartbeats", ["state"], :name => "index_heartbeats_on_state"
  add_index "heartbeats", ["user_id"], :name => "index_heartbeats_on_user_id"

  create_table "histories", :force => true do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.integer  "exampoint_id"
    t.string   "epmenu_id"
    t.string   "state"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "answer"
  end

  add_index "histories", ["answer"], :name => "index_histories_on_answer"
  add_index "histories", ["epmenu_id"], :name => "index_histories_on_epmenu_id"
  add_index "histories", ["exampoint_id"], :name => "index_histories_on_exampoint_id"
  add_index "histories", ["question_id"], :name => "index_histories_on_question_id"
  add_index "histories", ["state"], :name => "index_histories_on_state"

  create_table "import_errors", :force => true do |t|
    t.string   "title"
    t.integer  "import_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "details"
  end

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
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "state"
    t.string   "category"
    t.text     "blanks"
    t.integer  "ancestry_depth",     :default => 0
    t.integer  "score"
    t.string   "sound_file_name"
    t.string   "sound_content_type"
    t.integer  "sound_file_size"
    t.datetime "sound_updated_at"
    t.integer  "number"
    t.text     "questions_number"
  end

  add_index "laws", ["ancestry"], :name => "index_laws_on_ancestry"
  add_index "laws", ["ancestry_depth"], :name => "index_laws_on_ancestry_depth"
  add_index "laws", ["state"], :name => "index_laws_on_state"

  create_table "questions", :force => true do |t|
    t.text     "title"
    t.integer  "score"
    t.integer  "num"
    t.string   "state"
    t.text     "description"
    t.string   "answer"
    t.text     "choices"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.text     "description3"
    t.text     "choices_description"
  end

  add_index "questions", ["num"], :name => "index_questions_on_num"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "schools", :force => true do |t|
    t.string   "title"
    t.text     "details"
    t.string   "url"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "city"
    t.float    "price"
    t.string   "started_at"
  end

  create_table "searches", :force => true do |t|
    t.integer  "user_id"
    t.string   "searchable_type"
    t.string   "keyword"
    t.text     "result"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "action"
    t.integer  "searchable_id"
  end

  add_index "searches", ["action"], :name => "index_searches_on_action"
  add_index "searches", ["keyword"], :name => "index_searches_on_keyword"
  add_index "searches", ["searchable_id"], :name => "index_searches_on_searchable_id"
  add_index "searches", ["searchable_type"], :name => "index_searches_on_searchable"
  add_index "searches", ["user_id"], :name => "index_searches_on_user_id"

  create_table "settings", :force => true do |t|
    t.string   "var",                      :null => false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", :limit => 30
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "settings", ["thing_type", "thing_id", "var"], :name => "index_settings_on_thing_type_and_thing_id_and_var", :unique => true

  create_table "users", :force => true do |t|
    t.datetime "created_at",                                                                       :null => false
    t.datetime "updated_at",                                                                       :null => false
    t.string   "email",                                                                            :null => false
    t.string   "encrypted_password", :limit => 128,                                                :null => false
    t.string   "confirmation_token", :limit => 128
    t.string   "remember_token",     :limit => 128,                                                :null => false
    t.text     "dec"
    t.string   "username"
    t.decimal  "complex",                           :precision => 5, :scale => 4, :default => 0.0
    t.string   "qq"
    t.string   "phone"
    t.text     "signature"
    t.string   "nickname"
  end

  add_index "users", ["complex"], :name => "index_users_on_complex"
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
