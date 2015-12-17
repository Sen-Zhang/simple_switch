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

ActiveRecord::Schema.define(version: 20151216180633) do

  create_table "simple_switch_environments", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "simple_switch_environments", ["name"], name: "index_simple_switch_environments_on_name"

  create_table "simple_switch_features", force: :cascade do |t|
    t.string   "name",                    null: false
    t.string   "description", limit: 500
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "simple_switch_features", ["name"], name: "index_simple_switch_features_on_name"

  create_table "simple_switch_states", force: :cascade do |t|
    t.boolean  "status",         default: false
    t.integer  "feature_id"
    t.integer  "environment_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "simple_switch_states", ["environment_id"], name: "index_simple_switch_states_on_environment_id"
  add_index "simple_switch_states", ["feature_id"], name: "index_simple_switch_states_on_feature_id"

end
