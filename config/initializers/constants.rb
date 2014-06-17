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

# tactics positions
POSITION_GK = "GK"
POSITION_D_L = "LD"
POSITION_D_LC = "LCD"
POSITION_D_C = "CD"
POSITION_D_RC = "RCD"
POSITION_D_R = "RD"
POSITION_DM_L = "LDM"
POSITION_DM_LC = "LCDM"
POSITION_DM_C = "CDM"
POSITION_DM_RC = "RCDM"
POSITION_DM_R = "RDM"
POSITION_M_L = "LM"
POSITION_M_LC = "LCM"
POSITION_M_C = "CM"
POSITION_M_RC = "RCM"
POSITION_M_R = "RM"
POSITION_AM_L = "LAM"
POSITION_AM_LC = "LCAM"
POSITION_AM_C = "CAM"
POSITION_AM_RC = "RCAM"
POSITION_AM_R = "LAM"
POSITION_S_L = "LS"
POSITION_S_LC = "LCS"
POSITION_S_C = "CS"
POSITION_S_RC = "RCS"
POSITION_S_R = "RS"
POSITION_SUB = "SUB"

POSITION_ID = {
  POSITION_GK => 1,
  POSITION_D_L => 20,
  POSITION_D_LC => 21,
  POSITION_D_C => 22,
  POSITION_D_RC => 23,
  POSITION_D_R => 24,
  POSITION_DM_L => 30,
  POSITION_DM_LC => 31,
  POSITION_DM_C => 32,
  POSITION_DM_RC => 33,
  POSITION_DM_R => 34,
  POSITION_M_L => 40,
  POSITION_M_LC => 41,
  POSITION_M_C => 42,
  POSITION_M_RC => 43,
  POSITION_M_R => 44,
  POSITION_AM_L => 50,
  POSITION_AM_LC => 51,
  POSITION_AM_C => 52,
  POSITION_AM_RC => 53,
  POSITION_AM_R => 54,
  POSITION_S_L => 60,
  POSITION_S_LC => 61,
  POSITION_S_C => 62,
  POSITION_S_RC => 63,
  POSITION_S_R => 64,
  POSITION_SUB => 100
}

POSITION_BY_ID = []
POSITIONS = []
POSITIONS_SELECTABLE = []
POSITION_ID.each do |key, value|
  POSITION_BY_ID[value] = key;
  POSITIONS << [ key, value]
  if (key != POSITION_GK && key != POSITION_SUB)
    POSITIONS_SELECTABLE << [ key, value ]
  end
end

# default positions for new tactics
DEFAULT_TACTICS_POSITIONS = [
  POSITION_ID[POSITION_GK],
  POSITION_ID[POSITION_D_L],
  POSITION_ID[POSITION_D_LC],
  POSITION_ID[POSITION_D_RC],
  POSITION_ID[POSITION_D_R],
  POSITION_ID[POSITION_M_L],
  POSITION_ID[POSITION_M_LC],
  POSITION_ID[POSITION_M_RC],
  POSITION_ID[POSITION_M_R],
  POSITION_ID[POSITION_S_LC],
  POSITION_ID[POSITION_S_RC],
  POSITION_ID[POSITION_SUB],
  POSITION_ID[POSITION_SUB],
  POSITION_ID[POSITION_SUB],
  POSITION_ID[POSITION_SUB],
  POSITION_ID[POSITION_SUB],
  POSITION_ID[POSITION_SUB],
  POSITION_ID[POSITION_SUB]
]

# allowed lineups
LINEUPS = [
  {
    :name => "4-4-2",
    :positions => [
      POSITION_ID[POSITION_GK],
      POSITION_ID[POSITION_D_L],
      POSITION_ID[POSITION_D_LC],
      POSITION_ID[POSITION_D_RC],
      POSITION_ID[POSITION_D_R],
      POSITION_ID[POSITION_M_L],
      POSITION_ID[POSITION_M_LC],
      POSITION_ID[POSITION_M_RC],
      POSITION_ID[POSITION_M_R],
      POSITION_ID[POSITION_S_LC],
      POSITION_ID[POSITION_S_RC]
    ]
  },
  {
    :name => "4-5-1",
    :positions => [
      POSITION_ID[POSITION_GK],
      POSITION_ID[POSITION_D_L],
      POSITION_ID[POSITION_D_LC],
      POSITION_ID[POSITION_D_RC],
      POSITION_ID[POSITION_D_R],
      POSITION_ID[POSITION_M_L],
      POSITION_ID[POSITION_M_LC],
      POSITION_ID[POSITION_M_C],
      POSITION_ID[POSITION_M_RC],
      POSITION_ID[POSITION_M_R],
      POSITION_ID[POSITION_S_C]
    ]
  },
  {
    :name => "3-5-2",
    :positions => [
      POSITION_ID[POSITION_GK],
      POSITION_ID[POSITION_D_LC],
      POSITION_ID[POSITION_D_C],
      POSITION_ID[POSITION_D_RC],
      POSITION_ID[POSITION_M_L],
      POSITION_ID[POSITION_M_LC],
      POSITION_ID[POSITION_M_C],
      POSITION_ID[POSITION_M_RC],
      POSITION_ID[POSITION_M_R],
      POSITION_ID[POSITION_S_LC],
      POSITION_ID[POSITION_S_RC]
    ]
  },
  {
    :name => "4-3-3",
    :positions => [
      POSITION_ID[POSITION_GK],
      POSITION_ID[POSITION_D_L],
      POSITION_ID[POSITION_D_LC],
      POSITION_ID[POSITION_D_RC],
      POSITION_ID[POSITION_D_R],
      POSITION_ID[POSITION_M_LC],
      POSITION_ID[POSITION_M_C],
      POSITION_ID[POSITION_M_RC],
      POSITION_ID[POSITION_S_LC],
      POSITION_ID[POSITION_S_C],
      POSITION_ID[POSITION_S_RC]
    ]
  }
]


# game events
GAME_EVENT = {
  :goal => 1,
  :sub => 2,
  :yellow => 3,
  :red => 4,
  :penalty_yes => 5,
  :penalty_no => 6,
  :yellow_red => 7,
  :own_goal => 8,
  :injury => 9,
  :light_injury => 10
}

# off pitch reasons (for GamePlayer)
OFF_REASON = {
  :sub => nil,
  :red => 1,
  :second_yellow => 2,
  :injury => 3
}

# result types for game
GAME_RESULT_TYPE = {
  :standard => nil,
  :overtime => 1,
  :penalties => 2,
  :forfeit => 3
}

# other useful constants
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
SKIN = "default"

# folders
FOLDER_GAME_EVENTS = "game_events"
FLAGS = "flags"
FLAGS_SMALL = File.join(FLAGS, "small")
