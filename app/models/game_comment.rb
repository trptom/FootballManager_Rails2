class GameComment < ActiveRecord::Base
  attr_accessible :user, :user_id, :game, :game_id, :content
  
  belongs_to :user
  belongs_to :game
end
