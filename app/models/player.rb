class Player < ActiveRecord::Base
  attr_accessible :age, :aggresivness, :att, :deff, :first_name, :foot, :gk,
    :last_name, :mid, :passing, :potential, :pseudonym, :quality,
    :second_name, :shooting, :speed, :stamina, :icon,
    :country, :country_id,
    :team, :team_id
  
  belongs_to :country
  belongs_to :team
  has_many :player_stats
  has_many :game_players
  
  def get_position
    if gk == PLAYER_POSITION_MAX
      return PLAYER_POSITION_GK
    end
    if deff == PLAYER_POSITION_MAX
      return PLAYER_POSITION_D
    end
    if mid == PLAYER_POSITION_MAX
      return PLAYER_POSITION_M
    end
    if att == PLAYER_POSITION_MAX
      return PLAYER_POSITION_S
    end
    return nil
  end
  
  def get_name
    if pseudonym != nil
      return pseudonym
    end
    
    if first_name != nil
      if second_name != nil
        return first_name + " " + second_name + " " + last_name
      else
        return first_name + " " + last_name
      end
    end
    
    return last_name
  end
  
  def league_stats(league, season = Params.season)
    return player_stats.where(:league_id => league.id, :season => season).first
  end
end
