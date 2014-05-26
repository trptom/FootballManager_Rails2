class GameEvent < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  attr_accessible :type
end
