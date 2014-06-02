class TeamsController < ApplicationController
  def coefficients
    @coefs = TeamCoef.ordered_by_sum(Params.season-5, Params.season-1)
  end
  
  def show
    @team = Team.find(params[:id])
  end
  
  def squad
    @team = Team.find(params[:id])
    @players = @team.players
  end
  
  def tactics
    @team = filter_by_current_user_team(Team.find(params[:id]))
    @tactics = @team.tactics
  end
end
