class PlayerNamesController < ApplicationController
  def stats
    @first_names = Player.select("first_name, count(first_name) as counter").group(:first_name).order("counter DESC")
    @last_names = Player.select("last_name, count(last_name) as counter").group(:last_name).order("counter DESC")
  end
  
  def show
    @team = Team.find(params[:id])
  end
  
  def squad
    @team = Team.find(params[:id])
    @players = @team.players
  end
end
