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
    return game_players.where(:team_id => HOME_TEAM_ID).order(:position)
  end
  
  def away_players
    return game_players.where(:team_id => AWAY_TEAM_ID).order(:position)
  end
  
  def real_min
    return ((DateTime.now - gameTime.now) * 1440).ceil
  end
end
