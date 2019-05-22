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

ActiveRecord::Schema.define(version: 20190522101329) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "consumptions", force: :cascade do |t|
    t.datetime "time"
    t.integer "consumption"
    t.bigint "vehicle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "journey_id"
    t.decimal "lat"
    t.decimal "lon"
    t.index ["journey_id"], name: "index_consumptions_on_journey_id"
    t.index ["vehicle_id"], name: "index_consumptions_on_vehicle_id"
  end

  create_table "demand_predictions", force: :cascade do |t|
    t.decimal "value"
    t.datetime "datetime"
    t.string "sector"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "journeys", force: :cascade do |t|
    t.bigint "owner_id"
    t.bigint "vehicle_id"
    t.string "origin"
    t.string "destination"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "originLat"
    t.decimal "originLon"
    t.decimal "destinationLat"
    t.decimal "destinationLon"
    t.index ["owner_id"], name: "index_journeys_on_owner_id"
    t.index ["vehicle_id"], name: "index_journeys_on_vehicle_id"
  end

  create_table "owners", force: :cascade do |t|
    t.string "name"
    t.bigint "vehicle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["reset_password_token"], name: "index_owners_on_reset_password_token", unique: true
    t.index ["vehicle_id"], name: "index_owners_on_vehicle_id"
  end

  create_table "price_predictions", force: :cascade do |t|
    t.decimal "price"
    t.datetime "datetime"
    t.string "sector"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "charging_sector"
    t.integer "battery_capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "owner_id"
    t.decimal "latitude"
    t.decimal "longitude"
    t.decimal "chargerate"
    t.decimal "initialcharge"
    t.decimal "dischargerate"
    t.decimal "current_charge"
    t.string "imageurl"
    t.index ["owner_id"], name: "index_vehicles_on_owner_id"
  end

  add_foreign_key "consumptions", "journeys"
  add_foreign_key "consumptions", "vehicles"
  add_foreign_key "journeys", "owners"
  add_foreign_key "journeys", "vehicles"
  add_foreign_key "owners", "vehicles"
  add_foreign_key "vehicles", "owners"
end
