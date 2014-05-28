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
          Rails.logger.info("adding goalkeeper to " + team.name)
          p = PlayersHelper::generate_goalkeeper(team)
          s_players[PLAYER_POSITION_GK] << p
        elsif s_players[PLAYER_POSITION_D].count < TEAM_REFILL_PLAYERS_POS_TO[PLAYER_POSITION_D]
          Rails.logger.info("adding defender to " + team.name)
          p = PlayersHelper::generate_defender(team)
          s_players[PLAYER_POSITION_D] << p
        elsif s_players[PLAYER_POSITION_M].count < TEAM_REFILL_PLAYERS_POS_TO[PLAYER_POSITION_M]
          Rails.logger.info("adding midfielder to " + team.name)
          p = PlayersHelper::generate_midfielder(team)
          s_players[PLAYER_POSITION_M] << p
        elsif s_players[PLAYER_POSITION_S].count < TEAM_REFILL_PLAYERS_POS_TO[PLAYER_POSITION_S]
          Rails.logger.info("adding attacker to " + team.name)
          p = PlayersHelper::generate_attacker(team)
          s_players[PLAYER_POSITION_S] << p
        else
          Rails.logger.info("adding random position to " + team.name)
          p = PlayersHelper::generate_random(team)
        end
      end
    else
      Rails.logger.info "team " + team.name + " has " + team.players.count.to_s + " players - not neccessary to refill it"
    end
  end
end
