class Team < ActiveRecord::Base
  attr_accessible :name, :user, :user_id, :country, :country_id
  
  belongs_to :user
  belongs_to :country
  has_many :team_coefs, dependent: :destroy
  has_many :players
  has_many :tactics, dependent: :destroy
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
  
  def is_playing_game
    return games.where("(start > ?)AND(finished = ?)", DateTime.now, false).count > 0
  end
  
  # Returns all tactics sorted descendently by priority,
  def get_sorted_tactics
    return tactics.order("priority DESC")
  end
  
  # Returns primary tactics (highest priority) or nil when no tactics is
  # created.
  def get_primary_tactics
    t = self.get_sorted_tactics
    return t.count > 0 ? t.first : nil
  end
end
