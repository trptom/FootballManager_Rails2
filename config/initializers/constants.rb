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

DEFAULT_LEAGUE_AGAINST = 2 # default number of games each to each in standard league (when not changed in league.type_data)
ROUND_BARAGE_BASE = 10000 # id of barage game round. each id is specific by from_pos, e.g. if from_pos is 2, id is 10002
COEF_COUNT_YEARS = 5 # number of last seasons counted into coefficients