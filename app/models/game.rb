include GamesHelper 

class Game < ActiveRecord::Base
  attr_accessible :attendance, :finished, :min, :result_type,
    :score_away, :score_half_away, :score_half_home, :score_home,
    :season, :start, :started, :winner, :league, :league_id,
    :team_home, :team_home_id, :team_away, :team_away_id,
    :league, :league_id, :stadium, :stadium_id, :round
  
  belongs_to :league
  belongs_to :team_home, :class_name => "Team"
  belongs_to :team_away, :class_name => "Team"
  belongs_to :stadium
  has_many :game_players
  has_many :game_comments
  has_many :game_tactics
  has_many :game_events
  
  scope :played_by_league, ->(league) {
    where(:league_id => league.id, :started => false).order("start DESC")
  }
  
  scope :next_by_league, ->(league) {
    where(:league_id => league.id, :started => false).order(:start, :round)
  }
  
  scope :current_by_league, ->(league) {
    where(:league_id => league.id, :started => true, :finished => false).order(:start)
  }
   
  scope :previous_by_league, ->(league) {
    where(:league_id => league.id, :finished => true).order("start DESC, round desc")
  }
  
  def home_players
    return game_players.where(:team => HOME_TEAM_ID).order(:position)
  end
  
  def away_players
    return game_players.where(:team => AWAY_TEAM_ID).order(:position)
  end
  
  def home_players_on
    return home_players.where("position IS NOT NULL").order(:position)
  end
  
  def away_players_on
    return away_players.where("position IS NOT NULL").order(:position)
  end
  
  def home_players_off
    return home_players.where(:position => nil)
  end
  
  def away_players_off
    return away_players.where(:position => nil)
  end
  
  def real_min
    Rails.logger.info "fdafadhlfdjlafhadls------ " + (start).to_s
    return ((DateTime.now.to_i - start.to_i) / 60).ceil
  end
  
  # Prepares game data before it starts. Score is reset to 0 and default tactics
  # from currently selected tactics is created. This function has no
  # restrictions and controls (e.g. whether game  was already prepared) so be
  # careful with using it.
  # 
  # returns: result of preparation (true/false on error)
  def prepare
    GamesHelper::prepare(self)
  end
  
  # Simulates game until now. If game was in past (curent min > 90), it is
  # finished.
  # 
  # returns: result of simulation (true/false on error)
  def simulate
    result = true
    
    # if game should be started (and hasnt been yet), do it!
    if (start <= DateTime.now && !self.started)
      result = self.prepare && result
    end
    
    # When game already started, simulate all non-simulated minutes
    if self.started
      result = GamesHelper::simulate_previous_minutes(self) && result
    end
    
    return result
  end
  
  # Simulates one minute of game. This simulation has no restrictions and
  # controls (e.g. whether game is started and this minute was already
  # simulated) so be careful with using it.
  # 
  # returns: result of simulation (true/false on error)
  def simulate_minute(minute)
    res = true
    
    for team_id in 1..2
      # GOALS
      res = GamesHelper::simulate_goals(self, team_id, minute) && res
      
      # YELLOW CARDS
      res = GamesHelper::simulate_yellow_cards(self, team_id, minute) && res
    end
    
    return res
  end
end
