class LeagueTeam < ActiveRecord::Base
  attr_accessible :ga, :gf, :gdiff, :gp, :l, :lot, :note, :pts, :season, :t,
    :w, :wot, :team, :team_id, :league, :league_id, :stays_in_league
  
  belongs_to :league
  belongs_to :team
  
  scope :sorted, -> {
    order("pts DESC, gdiff DESC")
  }
end
