include PlayersHelper

# Helper module for working with teams.
module TeamsHelper
  
  # Adds players to team to match mimimum counts, specified in configuration
  # (+TEAM_REFILL_PLAYERS_TO+ constant). Players are created depending on
  # current squad. E.g. when team already has at least n (usually 2)
  # goalkeepers, no more goalkeepers are added and players for different
  # positions are created. Same for defenders, midfielders and attackers. Counts
  # for all od position types are defined in +TEAM_REFILL_PLAYERS_POS_TO+
  # constant.
  #
  # ==== Params
  # _team_:: team to which should be players added.
  #
  # ==== See
  # PlayersHelper (PlayersHelper functions for generating players are used in
  # this method), 
  # PlayersHelper#generate_goalkeeper, 
  # PlayersHelper#generate_defender, 
  # PlayersHelper#generate_midfielder, 
  # PlayersHelper#generate_attacker, 
  # PlayersHelper#generate_random
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
