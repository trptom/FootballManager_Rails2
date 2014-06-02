class TacticsController < ApplicationController
  def show
    @tactics = Tactics.find(params[:id])
    @team = filter_by_current_user_team(@tactics.team)
    
    @players = {
      :on => @tactics.tactics_players.players_on,
      :substitutors => @tactics.tactics_players.players_sub
    }
  end
  
  def create
    @tactics = Tactics.new(
      :name => "New tactics",
      :team_id => params[:team_id]
    )
    
    if @tactics.save
      redirect_to @tactics
    else
      redirect_to :back
    end
  end
  
  def add_player
    
  end
  
  def set_player_position
    
  end
  
  def remove_player
    
  end
end
