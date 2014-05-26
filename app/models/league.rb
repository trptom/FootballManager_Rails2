class League < ActiveRecord::Base
  attr_accessible :grp, :level, :logo, :shortcut, :country, :country_id, :league_type,
    :type_data
  
  belongs_to :country
  has_many :league_teams
  has_many :games
  has_many :promotions, :class_name => 'Promotion', :foreign_key => 'league_from_id'
  has_many :relegations, :class_name => 'Promotion', :foreign_key => 'league_to_id'
  
  serialize :type_data
  
  scope :by_user, ->(user) {
    select("leagues.*")
        .from("league_teams, teams, leagues")
        .where("(league_teams.team_id = teams.id)AND(league_teams.league_id = leagues.id)AND(teams.user_id = ?)", user.id)
  }
  
  scope :by_user_and_season, ->(user, season = Params.season) {
    select("leagues.*")
        .from("league_teams, teams, leagues")
        .where("(league_teams.team_id = teams.id)AND(league_teams.league_id = leagues.id)AND(teams.user_id = ?)AND(league_teams.season = ?)", user.id, season)
  }

  def teams(season = Params.season)
    return league_teams.where(:season => season)
  end
  
  def teams_count(season = Params.season)
    return teams(season).count
  end
  
  def current_teams
    return teams
  end
  
  def current_teams_count
    return teams.count
  end
end
