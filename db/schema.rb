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

ActiveRecord::Schema.define(version: 20160710040950) do

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.text     "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "food_options", force: :cascade do |t|
    t.integer  "food_id"
    t.integer  "option_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "foods", force: :cascade do |t|
    t.string   "name"
    t.integer  "price"
    t.string   "image_url"
    t.integer  "restaurant_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "cat_id"
    t.string   "cat"
    t.integer  "rec"
  end

  add_index "foods", ["restaurant_id"], name: "index_foods_on_restaurant_id"

  create_table "option_values", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.integer  "option_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "price"
  end

  add_index "option_values", ["option_id"], name: "index_option_values_on_option_id"

  create_table "options", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "option_type"
  end

  create_table "orders", force: :cascade do |t|
    t.decimal  "total"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "payment_type", default: 0
    t.integer  "rest_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "order_id"
    t.text     "omise_charge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "places", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "restaurant_categories", force: :cascade do |t|
    t.integer "restaurant_id"
    t.integer "category_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string   "name"
    t.text     "desc"
    t.string   "image_url"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.text     "address"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "min_order",  default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",           default: false
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "phone"
    t.text     "address"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "dinstruction"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
