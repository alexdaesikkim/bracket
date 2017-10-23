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

ActiveRecord::Schema.define(version: 20171003205816) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.string   "name"
    t.string   "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "min_level"
    t.integer  "max_level"
    t.string   "excel"
  end

  create_table "matches", force: :cascade do |t|
    t.integer  "challonge_match_id"
    t.integer  "tournament_id"
    t.integer  "player1_id"
    t.integer  "player2_id"
    t.integer  "player1_score"
    t.integer  "player2_score"
    t.integer  "winner_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "round"
    t.string   "bracket"
  end

  create_table "matchsets", force: :cascade do |t|
    t.integer  "picked_player_id"
    t.integer  "player1_score"
    t.integer  "player2_score"
    t.integer  "match_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "name"
    t.string   "difficulty"
    t.string   "level"
    t.boolean  "saved",            default: false
  end

  create_table "picks", force: :cascade do |t|
    t.integer  "player_id"
    t.string   "song_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "playermatches", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "match_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "playerqualifiers", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "qualifier_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "submitted",    default: false
    t.integer  "score",        default: 0
  end

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.integer  "challonge_player_id"
    t.integer  "qualifier_score"
    t.integer  "seed"
    t.integer  "place"
    t.integer  "tournament_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "wins",                default: 0
    t.integer  "losses",              default: 0
    t.integer  "set_wins",            default: 0
    t.integer  "set_losses",          default: 0
  end

  create_table "qualifiers", force: :cascade do |t|
    t.string   "name"
    t.integer  "number"
    t.boolean  "tiebreaker"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "tournament_id"
    t.integer  "level"
    t.string   "difficulty"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string   "name"
    t.integer  "challonge_tournament_id"
    t.integer  "game_id"
    t.boolean  "main_stage"
    t.boolean  "qualifier_stage"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "event"
    t.boolean  "finished",                default: false
    t.integer  "placements",              default: [],                 array: true
    t.boolean  "finalized",               default: false
  end

end
