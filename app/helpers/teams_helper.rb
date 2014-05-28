include PlayersHelper

module TeamsHelper
  def fill_squad(team)
    # TODO doplnovani soupisky
    
    s_players = team.get_splitted_squad
    add_count = TEAM_REFILL_PLAYERS_TO - team.players.count
    
    if add_count > 0
      Rails.logger.info "team " + team.name + " has " + team.players.count.to_s + " players - adding another " + add_count.to_s + " players"
      
      for a in 1..add_count
        if s_players[PLAYER_POSITION_GK].count < TEAM_REFILL_PLAYERS_POS_TO[PLAYER_POSITION_GK]
          p = PlayersHelper::generate_goalkeeper(team)
          s_players[PLAYER_POSITION_GK] << p
        elsif s_players[PLAYER_POSITION_GK].count < TEAM_REFILL_PLAYERS_POS_TO[PLAYER_POSITION_GK]
          p = PlayersHelper::generate_defender(team)
          s_players[PLAYER_POSITION_GK] << p
        elsif s_players[PLAYER_POSITION_GK].count < TEAM_REFILL_PLAYERS_POS_TO[PLAYER_POSITION_GK]
          p = PlayersHelper::generate_midfielder(team)
          s_players[PLAYER_POSITION_GK] << p
        elsif s_players[PLAYER_POSITION_GK].count < TEAM_REFILL_PLAYERS_POS_TO[PLAYER_POSITION_GK]
          p = PlayersHelper::generate_attacker(team)
          s_players[PLAYER_POSITION_GK] << p
        else
          p = PlayersHelper::generate_random(team)
          s_players[PLAYER_POSITION_GK] << p
        end
      end
    else
      Rails.logger.info "team " + team.name + " has " + team.players.count.to_s + " players - not neccessary to refill it"
    end
  end
end
