# coding:utf-8

# kam ma byt presmerovavano pri not_found
NOT_FOUND_PAGE_URL = "/404.html"

#role
ROLE = {
  :user => 0,
  :admin => 1,
  :root => 9999,
}

# aplikace
APPLICATION_NAME = "TPSFM" # TODO "TPS Football Manager"
APPLICATION_CREDITS_GROUP = "Tým TPSFM"

# renderovani
TITLE_PREFIX = "TPSFM .:. "
DEFAULT_TITLE = "TPSFM"

# defaultni hodnoty
DEFAULT_ROLE = ROLE[:user]

# nastaveni defaultniho admin uctu
ROOT_ACCOUNT_USERNAME = "admin"
ROOT_ACCOUNT_PASSWORD = "root"
ROOT_ACCOUNT_EMAIL = "admin@fmtps.com"
ROOT_ACCOUNT_ROLE = ROLE[:root]

# league types
LEAGUE_TYPE_STANDARD = 0;
LEAGUE_TYPE_CUP = 1;
LEAGUE_TYPE_CHAMPIONS_CUP = 100;

# player positions
PLAYER_POSITION_MAX = 100 # max value of position
PLAYER_POSITION_GK = :pos_gk
PLAYER_POSITION_D = :pos_d
PLAYER_POSITION_M = :pos_m
PLAYER_POSITION_S = :pos_s

DEFAULT_LEAGUE_AGAINST = 2 # default number of games each to each in standard league (when not changed in league.type_data)
ROUND_BARAGE_BASE = 10000 # id of barage game round. each id is specific by from_pos, e.g. if from_pos is 2, id is 10002
COEF_COUNT_YEARS = 5 # number of last seasons counted into coefficients
TEAM_MIN_PLAYERS = 15 # minimal number of players in team
TEAM_REFILL_PLAYERS_TO = 20 # number of players in team after it is refilled
TEAM_REFILL_PLAYERS_POS_TO = {
  PLAYER_POSITION_GK => 2,
  PLAYER_POSITION_D => 7,
  PLAYER_POSITION_M => 7,
  PLAYER_POSITION_S => 4
}
NAME_FREQUENCY_MIN = 1
NAME_FREQUENCY_MAX = 10
COUNTRY_COEF_FORMAT = "%0.3f" # format of country coef in coefficients table
TEAM_COEF_FORMAT = "%0.3f" # format of team coef in coefficients table
COUNTRY_MESSAGES_KEY = "countries." # section in locales where are located country names
LEAGUE_MESSAGES_KEY = "leagues." # section in locales where are located league names
HOME_TEAM_ID = 1 # ID used for home team in game
AWAY_TEAM_ID = 2 # ID used for away team in game

# folders
FLAGS = "flags"
FLAGS_SMALL = File.join(FLAGS, "small")