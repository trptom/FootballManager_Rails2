module LeaguesHelper
  def update_teams_league(league, season)
    if season != 1
      Rails.logger.info league.shortcut + " teams for " + season.to_s + ":"

      league_teams = league.teams.sorted

      stay = []
      for a in 0..league_teams.count-1
        stay[a] = true
      end

      for promotion in league.promotions
        stay[promotion.league_from_pos-1] = false

        if promotion.barage
          game = Game.where(:league_id => promotion.league_from_id, :round => (ROUND_BARAGE_BASE + promotion.league_from_pos)).first
          team = game.winner == 1 ? hame.team_away : game.team_home

          LeagueTeam.new(
            :league => league,
            :team => team,
            :season => season
          ).save

          Rails.logger.info "  " + team.name
        else
          team = promotion.league_to.teams.sorted[promotion.league_to_pos-1]

          LeagueTeam.new(
            :league => league,
            :team => team,
            :season => season
          ).save

          Rails.logger.info "  " + team.name
        end
      end

      for relegation in league.relegations
        stay[relegation.league_to_pos-1] = false

        if relegation.barage
          game = Game.where(:league_id => relegation.league_from_id, :round => (ROUND_BARAGE_BASE + relegation.league_from_pos)).first
          team = game.winner == 1 ? hame.team_home : game.team_away

          LeagueTeam.new(
            :league => league,
            :team => team,
            :season => season
          ).save

          Rails.logger.info "  " + team.name
        else
          team = relegation.league_from.teams.sorted[relegation.league_from_pos-1]

          LeagueTeam.new(
            :league => league,
            :team => team,
            :season => season
          ).save

          Rails.logger.info "  " + team.name
        end
      end

      for a in 0..league_teams.count-1
        if stay[a]
          LeagueTeam.new(
            :league => league,
            :team => league_teams[a].team,
            :season => season
          ).save

          Rails.logger.info "  " + team.name
        end
      end
    else
      Rails.logger.info league.shortcut + " teams not updated - 1st season is used default DB"
    end
  end
  
  def update_teams_national_cup(league, season)
    Rails.logger.info league.shortcut + " teams for " + season.to_s + ":"
    
    for team in league.country.teams
      LeagueTeam.new(
        :league => league,
        :team => team,
        :season => season
      ).save
      
      Rails.logger.info "  " + team.name
    end
  end
  
  def update_teams_champions_cup(league, season)
    if season != 1 # first season isnt champions cup played
    else
      Rails.logger.info league.shortcut + " teams not updated - 1st season isnt this competition played"
    end
  end
  
  def update_teams(league, season)
    case league.league_type
    when LEAGUE_TYPE_STANDARD
      update_teams_league(league, season)
    when LEAGUE_TYPE_CUP
      update_teams_national_cup(league, season)
    when LEAGUE_TYPE_CHAMPIONS_CUP
      update_teams_champions_cup(league, season)
    else
      Rails.logger.error "Invalid league type (" + league.league_type.to_s + ")"
    end
  end
  
  def draw_league(league, season)
    teams_count = league.teams_count(season)
    
    Rails.logger.info "GAMES: " +GAMES.to_s
    
    Rails.logger.info "drawing league " + league.shortcut + " for season " + season.to_s
    Rails.logger.info "  teams_count: " + teams_count.to_s
    
    if GAMES[teams_count] != nil
      Rails.logger.info "    teams count ok: " + teams_count.to_s
      
      against = league.type_data != nil && league.type_data[:against] != nil ? league.type_data[:against] : DEFAULT_LEAGUE_AGAINST
      Rails.logger.info "  against: " + against.to_s
      Rails.logger.info "  rounds: " + GAMES[teams_count].length.to_s
      
      team_ids = (0..teams_count-1).to_a.shuffle!
      teams_orig = league.teams(season)
      teams = [nil]
      for a in 0..teams_count-1
        teams << teams_orig[team_ids[a]]
      end
      
      total_rounds = against * GAMES[teams_count].length
      for a in 0..against-1
        for b in 1..GAMES[teams_count].length
          round = (a*GAMES[teams_count].length + b)
          date = DateTime.now + ((round*2)-1).days
          
          Rails.logger.info "  round " + round.to_s
          
          for c in 1..GAMES[teams_count][b].length
            home_team = GAMES[teams_count][b][c][a % 2]
            away_team = GAMES[teams_count][b][c][1 - (a % 2)]
            
            time_array = GAME_START[LEAGUE_TYPE_STANDARD][date.wday]
            time = time_array[round < total_rounds-2 ? rand(time_array.length) : 0] # last 2 rounds have al games same start time - [0] of list of times for specified day
            game_date = date.change({:hour => time[0] , :min => time[1]}) # TODO nefuguje offset, vsechno je -2h 
            
            game = Game.new(
              :league => league,
              :season => Params.season,
              :round => round,
              :start => game_date,
              :team_home => teams[home_team].team,
              :team_away => teams[away_team].team,
              :stadium => Stadium.first # TODO stadium for new game
            )

            Rails.logger.info "    " + time.to_s + ": " + teams[home_team].team.name + " vs. " + teams[away_team].team.name
            
            game.save
          end
          
          Rails.logger.info "  round " + (a*GAMES[teams_count].length + b).to_s + " drawn"
        end
      end
    else
      Rails.logger.info "unknown teams count: " + teams_count.to_s
    end
    # TODO losovani ligy
  end
  
  def draw_national_cup(league, season)
    # TODO losovani poharu
  end
  
  def draw_champions_cup(league, season)
    # TODO losovani CL
  end
  
  def draw(league, season)
    case league.league_type
    when LEAGUE_TYPE_STANDARD
      draw_league(league, season)
    when LEAGUE_TYPE_CUP
      draw_national_cup(league, season)
    when LEAGUE_TYPE_CHAMPIONS_CUP
      draw_champions_cup(league, season)
    else
      Rails.logger.error "Invalid league type (" + league.league_type.to_s + ")"
    end
  end
end
