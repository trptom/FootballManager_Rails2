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

ActiveRecord::Schema.define(:version => 20140527132918) do

  create_table "actions", :force => true do |t|
    t.text     "content",    :null => false
    t.integer  "type",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "provider",   :null => false
    t.string   "uid",        :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "countries", :force => true do |t|
    t.string   "shortcut",   :null => false
    t.string   "image"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "country_coef_qualyfications", :force => true do |t|
    t.integer  "position",                           :null => false
    t.integer  "teams_champions_cup", :default => 0, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "country_coefs", :force => true do |t|
    t.integer  "country_id",                  :null => false
    t.integer  "season",                      :null => false
    t.decimal  "coef",       :default => 0.0, :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "country_coefs", ["country_id"], :name => "index_country_coefs_on_country_id"
  add_index "country_coefs", ["season"], :name => "index_country_coefs_on_season"

  create_table "game_actions", :force => true do |t|
    t.integer  "game_id",    :null => false
    t.integer  "action_id",  :null => false
    t.integer  "minute",     :null => false
    t.text     "data",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "game_actions", ["action_id"], :name => "index_game_actions_on_action_id"
  add_index "game_actions", ["game_id"], :name => "index_game_actions_on_game_id"

  create_table "game_events", :force => true do |t|
    t.integer  "game_id",    :null => false
    t.integer  "player_id",  :null => false
    t.integer  "type",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "game_events", ["game_id"], :name => "index_game_events_on_game_id"
  add_index "game_events", ["player_id"], :name => "index_game_events_on_player_id"

  create_table "games", :force => true do |t|
    t.integer  "league_id",                          :null => false
    t.integer  "season",                             :null => false
    t.integer  "round"
    t.datetime "start",                              :null => false
    t.integer  "team_home_id",                       :null => false
    t.integer  "team_away_id",                       :null => false
    t.integer  "score_home"
    t.integer  "score_away"
    t.integer  "score_half_home"
    t.integer  "score_half_away"
    t.integer  "stadium_id",                         :null => false
    t.integer  "attendance"
    t.integer  "winner"
    t.integer  "result_type"
    t.boolean  "started",         :default => false, :null => false
    t.boolean  "finished",        :default => false, :null => false
    t.integer  "min"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "games", ["league_id"], :name => "index_games_on_league_id"
  add_index "games", ["season"], :name => "index_games_on_season"
  add_index "games", ["stadium_id"], :name => "index_games_on_stadium_id"
  add_index "games", ["team_away_id"], :name => "index_games_on_team_away_id"
  add_index "games", ["team_home_id"], :name => "index_games_on_team_home_id"

  create_table "league_teams", :force => true do |t|
    t.integer  "league_id",                 :null => false
    t.integer  "team_id",                   :null => false
    t.integer  "season",                    :null => false
    t.integer  "gp",         :default => 0, :null => false
    t.integer  "w",          :default => 0, :null => false
    t.integer  "wot",        :default => 0, :null => false
    t.integer  "t",          :default => 0, :null => false
    t.integer  "lot",        :default => 0, :null => false
    t.integer  "l",          :default => 0, :null => false
    t.integer  "gf",         :default => 0, :null => false
    t.integer  "ga",         :default => 0, :null => false
    t.integer  "gdiff",      :default => 0, :null => false
    t.integer  "pts",        :default => 0, :null => false
    t.text     "note"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "league_teams", ["league_id"], :name => "index_league_teams_on_league_id"
  add_index "league_teams", ["season"], :name => "index_league_teams_on_season"
  add_index "league_teams", ["team_id"], :name => "index_league_teams_on_team_id"

  create_table "leagues", :force => true do |t|
    t.string   "shortcut",                   :null => false
    t.integer  "country_id"
    t.integer  "league_type",                :null => false
    t.text     "type_data"
    t.integer  "level",       :default => 1, :null => false
    t.integer  "grp"
    t.string   "logo"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "leagues", ["country_id"], :name => "index_leagues_on_country_id"

  create_table "params", :force => true do |t|
    t.string   "param_name",  :null => false
    t.text     "param_value"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "players", :force => true do |t|
    t.string   "first_name",   :null => false
    t.string   "second_name"
    t.string   "last_name",    :null => false
    t.string   "pseudonym"
    t.integer  "age",          :null => false
    t.float    "gk",           :null => false
    t.float    "def",          :null => false
    t.float    "mid",          :null => false
    t.float    "att",          :null => false
    t.float    "shooting",     :null => false
    t.float    "passing",      :null => false
    t.float    "stamina",      :null => false
    t.float    "speed",        :null => false
    t.float    "aggresivness", :null => false
    t.integer  "quality",      :null => false
    t.integer  "potential",    :null => false
    t.integer  "foot",         :null => false
    t.integer  "country_id",   :null => false
    t.string   "icon"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "players", ["country_id"], :name => "index_players_on_country_id"

  create_table "promotions", :force => true do |t|
    t.integer  "league_from_id",                     :null => false
    t.integer  "league_from_pos",                    :null => false
    t.integer  "league_to_id",                       :null => false
    t.integer  "league_to_pos",                      :null => false
    t.boolean  "barage",          :default => false, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "promotions", ["league_from_id"], :name => "index_promotions_on_league_from_id"
  add_index "promotions", ["league_to_id"], :name => "index_promotions_on_league_to_id"

  create_table "stadia", :force => true do |t|
    t.integer  "team_id",    :null => false
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "stadia", ["team_id"], :name => "index_stadia_on_team_id"

  create_table "stadium_stands", :force => true do |t|
    t.integer  "stadium_id",                    :null => false
    t.integer  "location",                      :null => false
    t.integer  "level",       :default => 0,    :null => false
    t.integer  "type",        :default => 0,    :null => false
    t.float    "angle",       :default => 20.0, :null => false
    t.integer  "rows",        :default => 10,   :null => false
    t.integer  "capacity",                      :null => false
    t.integer  "maintenance", :default => 0,    :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "stadium_stands", ["stadium_id"], :name => "index_stadium_stands_on_stadium_id"

  create_table "team_coefs", :force => true do |t|
    t.integer  "team_id",                     :null => false
    t.integer  "season",                      :null => false
    t.decimal  "coef",       :default => 0.0, :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "team_coefs", ["season"], :name => "index_team_coefs_on_season"
  add_index "team_coefs", ["team_id"], :name => "index_team_coefs_on_team_id"

  create_table "teams", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "user_id"
    t.integer  "country_id", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "teams", ["country_id"], :name => "index_teams_on_country_id"
  add_index "teams", ["user_id"], :name => "index_teams_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "username",                                           :null => false
    t.string   "email",                                              :null => false
    t.string   "crypted_password"
    t.string   "salt"
    t.integer  "role",                            :default => 0,     :null => false
    t.string   "first_name"
    t.string   "second_name"
    t.boolean  "blocked",                         :default => false, :null => false
    t.datetime "block_expires_at"
    t.string   "activation_state"
    t.string   "activation_token"
    t.datetime "activation_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "icon"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
  end

end
