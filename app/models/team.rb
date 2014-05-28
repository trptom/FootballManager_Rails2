class Team < ActiveRecord::Base
  attr_accessible :name, :user, :user_id, :country, :country_id
  
  belongs_to :user
  belongs_to :country
  has_many :league_teams
  has_many :team_coefs
  has_many :home_games, :class_name => 'Game', :foreign_key => 'team_home_id'
  has_many :away_games, :class_name => 'Game', :foreign_key => 'team_away_id'
  
  def games
    return Game.where("(team_home_id = ?)OR(team_away_id = ?)", id, id)
  end
  
  def ordered_league_teams
    return league_teams.order(:points)
  end
  
end
