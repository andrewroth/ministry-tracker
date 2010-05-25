# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100525190119) do

  create_table "columns", :force => true do |t|
    t.string   "title"
    t.string   "update_clause"
    t.string   "from_clause"
    t.text     "select_clause"
    t.string   "column_type"
    t.string   "writeable"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "join_clause"
    t.string   "source_model"
    t.string   "source_column"
    t.string   "foreign_key"
  end

  create_table "conference_registrations", :force => true do |t|
    t.integer  "conference_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conferences", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "custom_attributes", :force => true do |t|
    t.integer "ministry_id"
    t.string  "name"
    t.string  "value_type"
    t.string  "description"
    t.string  "type"
  end

  add_index "custom_attributes", ["type"], :name => "index_custom_attributes_on_type"

  create_table "custom_values", :force => true do |t|
    t.integer "person_id"
    t.integer "custom_attribute_id"
    t.string  "value"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.string   "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.text     "people_ids"
    t.text     "missing_address_ids"
    t.integer  "search_id"
    t.integer  "sender_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "free_times", :force => true do |t|
    t.integer  "start_time"
    t.integer  "end_time"
    t.integer  "day_of_week"
    t.integer  "timetable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "css_class"
    t.decimal  "weight",       :precision => 4, :scale => 2
  end

  create_table "group_involvements", :force => true do |t|
    t.integer "person_id"
    t.integer "group_id"
    t.string  "level"
    t.boolean "requested"
  end

  add_index "group_involvements", ["person_id", "group_id"], :name => "person_id_group_id", :unique => true

  create_table "group_types", :force => true do |t|
    t.integer  "ministry_id"
    t.string   "group_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "mentor_priority"
    t.boolean  "public"
    t.integer  "unsuitability_leader"
    t.integer  "unsuitability_coleader"
    t.integer  "unsuitability_participant"
  end

  create_table "groups", :force => true do |t|
    t.string  "name"
    t.string  "address"
    t.string  "address_2"
    t.string  "city"
    t.string  "state"
    t.string  "zip"
    t.string  "country"
    t.string  "email"
    t.string  "url"
    t.integer "dorm_id"
    t.integer "ministry_id"
    t.integer "campus_id"
    t.integer "start_time"
    t.integer "end_time"
    t.integer "day"
    t.integer "group_type_id"
    t.boolean "needs_approval"
  end

  add_index "groups", ["campus_id"], :name => "index_groups_on_campus_id"
  add_index "groups", ["dorm_id"], :name => "index_groups_on_dorm_id"
  add_index "groups", ["ministry_id"], :name => "index_groups_on_ministry_id"

  create_table "imports", :force => true do |t|
    t.integer  "person_id"
    t.integer  "parent_id"
    t.integer  "size"
    t.integer  "height"
    t.integer  "width"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ministry_role_permissions", :force => true do |t|
    t.integer "permission_id"
    t.integer "ministry_role_id"
    t.string  "created_at"
  end

  create_table "permissions", :force => true do |t|
    t.string "description", :limit => 1000
    t.string "controller"
    t.string "action"
  end

  create_table "searches", :force => true do |t|
    t.integer  "person_id"
    t.text     "options"
    t.text     "query"
    t.text     "tables"
    t.boolean  "saved"
    t.string   "name"
    t.string   "order"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "staff", :force => true do |t|
    t.integer "ministry_id"
    t.integer "person_id"
    t.date    "created_at"
  end

  add_index "staff", ["ministry_id"], :name => "index_staff_on_ministry_id"

  create_table "stint_applications", :force => true do |t|
    t.integer  "stint_location_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stint_locations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "summer_project_applications", :force => true do |t|
    t.integer  "summer_project_id"
    t.integer  "person_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "summer_projects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timetables", :force => true do |t|
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "training_answers", :force => true do |t|
    t.integer  "training_question_id"
    t.integer  "person_id"
    t.date     "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "approved_by"
  end

  create_table "training_categories", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ministry_id"
  end

  create_table "training_question_activations", :force => true do |t|
    t.integer  "ministry_id"
    t.integer  "training_question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "mandate"
  end

  create_table "training_questions", :force => true do |t|
    t.string   "activity"
    t.integer  "ministry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "training_category_id"
  end

  create_table "view_columns", :force => true do |t|
    t.string   "view_id"
    t.string   "column_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "view_columns", ["column_id", "view_id"], :name => "view_columns_column_id"
  add_index "view_columns", ["view_id"], :name => "index_view_columns_on_view_id"

  create_table "views", :force => true do |t|
    t.string   "title"
    t.string   "ministry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "default_view"
    t.string   "select_clause", :limit => 2000
    t.string   "tables_clause", :limit => 2000
  end

end
