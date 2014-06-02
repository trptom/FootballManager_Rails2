class TacticsController < ApplicationController
  def show
    @tactics = Tactics.find(params[:id])
    @team = filter_by_current_user_team(@tactics.team)
    
    @players = {
      :on => @tactics.tactics_players.players_on,
      :substitutors => @tactics.tactics_players.players_sub
    }
    
    @player_list = @team.players.map{ |p| [ p.get_name, p.id, {
      :'data-name' => p.get_name,
      :'data-flag' => p.country.get_flag_url(FLAGS_SMALL),
      :'data-age' => p.age.to_s + " " + I18n.t("messages.base.years"),
      
      :'data-gk' => p.gk.round,
      :'data-def' => p.deff.round,
      :'data-mid' => p.mid.round,
      :'data-att' => p.att.round
    } ] }
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
