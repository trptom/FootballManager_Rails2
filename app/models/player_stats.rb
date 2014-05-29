class PlayerStats < ActiveRecord::Base
  belongs_to :player
  belongs_to :league
  attr_accessible :assists, :goals, :gp, :r_cards, :rnk, :season, :y_cards
end
