class TacticsPlayer < ActiveRecord::Base
  attr_accessible :position, :tactics, :tactics_id, :player, :player_id
  
  belongs_to :tactics
  belongs_to :player
  
  scope :players_on, -> {
    where("(position > ?)AND(position < ?)", 0, POSITION_ID[POSITION_SUB]).order(:position)
  }
  
  scope :players_sub, -> {
    where(:position => POSITION_ID[POSITION_SUB])
  }
end
