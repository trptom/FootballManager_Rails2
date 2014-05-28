class Team < ActiveRecord::Base
  attr_accessible :name, :user, :user_id, :country, :country_id
  
  belongs_to :user
  belongs_to :country
  has_many :league_teams
  has_many :team_coefs
  has_many :players
  has_many :home_games, :class_name => 'Game', :foreign_key => 'team_home_id'
  has_many :away_games, :class_name => 'Game', :foreign_key => 'team_away_id'
  
  def games
    return Game.where("(team_home_id = ?)OR(team_away_id = ?)", id, id)
  end
  
  def ordered_league_teams
    return league_teams.order(:points)
  end
  
  # splits squad to hash with keys :gk (array of all goalkeepers),
  # :d (all defenders), :m (all midfielders), :s (all strikers) and
  # :undefined (all players with no specified position; should be empty,
  # each player should have at least one position on top)
  #
  # serves mainly to automatical squad refill (I need to know which types of
  # players do I have)
  def get_splitted_squad
    ret = {
      PLAYER_POSITION_GK => [],
      PLAYER_POSITION_D => [],
      PLAYER_POSITION_M => [],
      PLAYER_POSITION_S => [],
      :undefined => []
    }
    
    for player in players
      tmp = player.get_position
      if tmp != nil
        ret[tmp] << player
      else
        ret[:undefined] << player
      end
    end
    
    return ret
  end
end
