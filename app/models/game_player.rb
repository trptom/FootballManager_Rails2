class GamePlayer < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  attr_accessible :min_off, :min_on, :position, :team, :game, :game_id,
    :player, :player_id, :reason_off
  
  scope :on_pitch, -> {
    where("(min_on IS NOT NULL)AND(min_off IS NULL)")
  }
  
  scope :position_in_range, ->(min_pos, max_pos) {
    where("(position >= ?)AND(position <= ?)", min_pos, max_pos)
  }

  scope :goalkeepers, ->() {
    position_in_range(POSITION_ID[POSITION_GK], POSITION_ID[POSITION_GK])
  }
  
  scope :defenders, ->() {
    position_in_range(POSITION_ID[POSITION_D_L], POSITION_ID[POSITION_D_R])
  }
  
  scope :midfielders, ->() {
    position_in_range(POSITION_ID[POSITION_DM_L], POSITION_ID[POSITION_AM_R])
  }
  
  scope :attackers, ->() {
    position_in_range(POSITION_ID[POSITION_S_L], POSITION_ID[POSITION_S_R])
  }
end
