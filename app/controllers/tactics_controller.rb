class TacticsController < ApplicationController
  def show
    @tactics = Tactics.find(params[:id])
    @team = filter_by_current_user_team(@tactics.team)
    
    # list of currently selected players
    @players = {
      :on => @tactics.tactics_players.players_on,
      :substitutors => @tactics.tactics_players.players_sub
    }
    
    # set list of players for select
    @player_list = @team.players.map{ |p| [ p.get_name, p.id, {
      :'data-name' => p.get_name,
      :'data-flag' => p.country.get_flag_url(FLAGS_SMALL),
      :'data-age' => p.age.to_s + " " + I18n.t("messages.base.years"),
      
      :'data-gk' => p.gk.round,
      :'data-def' => p.deff.round,
      :'data-mid' => p.mid.round,
      :'data-att' => p.att.round
    } ] }

    @player_list << [
      I18n.t("messages.tactics.show.no_player"),
      -1,
      {
        :'data-name' => I18n.t("messages.tactics.show.no_player")
      }
    ]

    @positions = (-1..(@tactics.tactics_players.count-1)).to_a
    
    @lineups = LINEUPS.map{ |l| [ l[:name], l[:positions].join(",")] }
    @lineups.unshift(["", ""])
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
  
  def update
    @tactics = Tactics.find(params[:id])
    @res = true
    
    if (params[:positions])
      for pos in params[:positions]
        data = pos[1]
        p = @tactics.tactics_players.find(data[:id].to_i)
        
        p_id = data[:player].to_i
        
        p.player_id = p_id >= 0 ? p_id : nil
        p.position = data[:position].to_i
        
        @res = @res & p.save
      end
    end
    
    render :json => {
      :result => @res
    }
  end
end
