class GameAction < ActiveRecord::Base
  belongs_to :game
  belongs_to :action
  attr_accessible :data, :minute
end
