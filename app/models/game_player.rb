class GamePlayer < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  attr_accessible :min_off, :min_on, :position, :team
end
