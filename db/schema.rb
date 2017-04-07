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

ActiveRecord::Schema.define(version: 20170407183239) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "countries", force: :cascade do |t|
    t.string   "countryname"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "experts", force: :cascade do |t|
    t.string   "name"
    t.decimal  "quality_score"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "leagues", force: :cascade do |t|
    t.integer  "country_id"
    t.string   "leaguename"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "league_reference"
  end

  create_table "matches", force: :cascade do |t|
    t.integer  "league_id"
    t.integer  "old_reference"
    t.integer  "round"
    t.datetime "date"
    t.integer  "home_team_id"
    t.integer  "away_team_id"
    t.integer  "home_goals"
    t.integer  "away_goals"
    t.integer  "home_goals_halftime"
    t.integer  "away_goals_halftime"
    t.string   "status"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "home_goals_first_half"
    t.integer  "away_goals_first_half"
    t.integer  "home_goals_second_half"
    t.integer  "away_goals_second_half"
    t.string   "match_url"
    t.string   "match_referencer"
    t.string   "season"
    t.index ["league_id"], name: "index_matches_on_league_id", using: :btree
  end

  create_table "odds", force: :cascade do |t|
    t.string   "provider"
    t.decimal  "home_odd"
    t.decimal  "draw_odd"
    t.decimal  "away_odd"
    t.integer  "match_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_odds_on_match_id", using: :btree
  end

  create_table "predictions", force: :cascade do |t|
    t.integer  "match_id"
    t.integer  "expert_id"
    t.decimal  "home_probability"
    t.decimal  "draw_probability"
    t.decimal  "away_probability"
    t.integer  "home_goals_predicted"
    t.integer  "away_goals_predicted"
    t.string   "winner_predicted"
    t.decimal  "home_probability_halftime"
    t.decimal  "draw_probability_halftime"
    t.decimal  "away_probability_halftime"
    t.decimal  "over_15_goals_probability"
    t.decimal  "over_25_goals_probability"
    t.decimal  "over_35_goals_probability"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["expert_id"], name: "index_predictions_on_expert_id", using: :btree
  end

  create_table "team_mappings", force: :cascade do |t|
    t.string   "longname"
    t.string   "zulubet"
    t.string   "statarea"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "proprediction"
    t.string   "bettingclosed"
    t.string   "hintwise"
    t.string   "iqbet"
    t.string   "prosoccereu"
    t.string   "prosoccergr"
    t.string   "shortname"
    t.integer  "reference"
    t.integer  "team_id"
    t.string   "betexplorer"
    t.string   "windrawwin"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                             default: "",    null: false
    t.string   "encrypted_password",                default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.boolean  "admin",                             default: false, null: false
    t.string   "authentication_token",   limit: 30
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "matches", "leagues"
  add_foreign_key "odds", "matches"
end
