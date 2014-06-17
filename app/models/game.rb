include GameSimulationHelper

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
  
  # Simulates game until now. If game was in past (curent min > 90), it is
  # finished.
  # 
  # returns: result of simulation (true/false on error)
  def simulate
    result = true
    simulator = GameSimulator.new(self)
    
    # if game should be started (and hasnt been yet), do it!
    if (self.start <= DateTime.now && !self.started)
      result = simulator.prepare && result
    end
    
    # When game already started, simulate all non-simulated minutes
    if self.started
      result = simulator.simulate_previous_minutes && result
    end
    
    return result
  end
end
