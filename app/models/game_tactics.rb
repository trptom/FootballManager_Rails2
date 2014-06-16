class GameTactics < ActiveRecord::Base
  belongs_to :game
  attr_accessible :aggressiveness, :passing, :shooting, :style, :team, :game, :game_id
end
