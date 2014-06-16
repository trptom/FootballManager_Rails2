class GameEvent < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  attr_accessible :event_type, :minute, :team, :game, :game_id, :player, :player_id
end
