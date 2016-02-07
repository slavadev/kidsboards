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

ActiveRecord::Schema.define(version: 20_160_202_185_421) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'actions', force: :cascade do |t|
    t.integer  'diff', default: 0
    t.integer  'user_id'
    t.integer  'goal_id'
    t.integer  'adult_id'
    t.datetime 'created_at'
  end

  add_index 'actions', ['adult_id'], name: 'index_actions_on_adult_id', using: :btree
  add_index 'actions', ['goal_id'], name: 'index_actions_on_goal_id', using: :btree
  add_index 'actions', ['id'], name: 'index_actions_on_id', using: :btree
  add_index 'actions', ['user_id'], name: 'index_actions_on_user_id', using: :btree

  create_table 'adults', force: :cascade do |t|
    t.string   'name', default: ''
    t.string   'photo_url'
    t.integer  'user_id'
    t.datetime 'deleted_at'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'adults', ['id'], name: 'index_adults_on_id', using: :btree
  add_index 'adults', ['user_id'], name: 'index_adults_on_user_id', using: :btree

  create_table 'children', force: :cascade do |t|
    t.string   'name', default: ''
    t.string   'photo_url'
    t.integer  'user_id'
    t.datetime 'deleted_at'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'children', ['id'], name: 'index_children_on_id', using: :btree
  add_index 'children', ['user_id'], name: 'index_children_on_user_id', using: :btree

  create_table 'families', force: :cascade do |t|
    t.string   'name', default: ''
    t.string   'photo_url'
    t.integer  'user_id'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'families', ['id'], name: 'index_families_on_id', using: :btree
  add_index 'families', ['user_id'], name: 'index_families_on_user_id', using: :btree

  create_table 'goals', force: :cascade do |t|
    t.string   'name', default: ''
    t.string   'photo_url'
    t.integer  'target'
    t.integer  'current'
    t.integer  'user_id'
    t.integer  'child_id'
    t.datetime 'deleted_at'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'goals', ['child_id'], name: 'index_goals_on_child_id', using: :btree
  add_index 'goals', ['id'], name: 'index_goals_on_id', using: :btree
  add_index 'goals', ['user_id'], name: 'index_goals_on_user_id', using: :btree

  create_table 'photos', force: :cascade do |t|
    t.string   'file_file_name'
    t.string   'file_content_type'
    t.integer  'file_file_size'
    t.datetime 'file_updated_at'
    t.integer  'user_id'
    t.datetime 'deleted_at'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'photos', ['id'], name: 'index_photos_on_id', using: :btree
  add_index 'photos', ['user_id'], name: 'index_photos_on_user_id', using: :btree

  create_table 'tokens', force: :cascade do |t|
    t.string   'code', default: ''
    t.boolean  'is_expired'
    t.integer  'token_type'
    t.integer  'user_id'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'tokens', ['id'], name: 'index_tokens_on_id', using: :btree
  add_index 'tokens', ['user_id'], name: 'index_tokens_on_user_id', using: :btree

  create_table 'users', force: :cascade do |t|
    t.string   'email',              default: ''
    t.string   'encrypted_password', default: ''
    t.string   'salt',               default: ''
    t.datetime 'confirmed_at'
    t.string   'pin', default: '0000'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'users', ['email'], name: 'index_users_on_email', using: :btree
  add_index 'users', ['id'], name: 'index_users_on_id', using: :btree

  add_foreign_key 'actions', 'adults'
  add_foreign_key 'actions', 'goals'
  add_foreign_key 'actions', 'users'
  add_foreign_key 'adults', 'users'
  add_foreign_key 'children', 'users'
  add_foreign_key 'families', 'users'
  add_foreign_key 'goals', 'children'
  add_foreign_key 'goals', 'users'
  add_foreign_key 'photos', 'users'
  add_foreign_key 'tokens', 'users'
end
