# TODO v tomhle filu je desnej bordel - mel bych prejit na pouzivani classes (nahore)

# Helper module for working with leagues (drawing, promoting teams ...).
module LeaguesHelper
  
  # Class used for drawing all types of competitions. It is inherited with lot
  # of childs, which have league_type specific drawing.
  class CompetitionDrawer
    @league = nil
    
    def initialize(league)
      @league = league
    end
    
    # Shuffles numbers from 0..+teams_count-1+ and returns array of them.
    #
    # ==== Params
    # _teams_count_:: count of items in array (each item is different).
    # 
    # ==== Returns
    # _Array_:: shuffeled array of numbers 0..+teams_count-1+.
    protected
    def get_shuffeled_team_ids(teams_count)
      return (0..teams_count-1).to_a.shuffle!
    end
    
    # Shuffles teams into random order.
    #
    # ==== Params
    # _teams_orig_:: Original record of teams from ratabase (not array or
    #                something like that!).
    #
    # ==== Returns
    # _Array_:: array of shuffeled teams.
    #
    # ==== See
    # CompetitionDrawer#get_shuffeled_team_ids
    protected
    def get_shuffeled_teams(teams_orig)
      team_ids = self.get_shuffeled_team_ids(teams_orig.count)
      teams = [nil]

      for a in 0..teams_count-1
        teams << teams_orig[team_ids[a]]
      end
      
      return teams
    end
    
    # Selects and returns default stadium for game.
    # 
    # ==== Params
    # _game_:: game for which should be default stadium found.
    # 
    # ==== Returns
    # _Stadium_:: instance of default stadium for game.
    protected
    def get_default_stadium_for_game(game)
      return Stadium.first # TODO stadium for new game
    end
  end
  
  # Drawer class for standard league.
  class StandardLeagueDrawer < CompetitionDrawer
    # Determines whether some games for specified season were already drawn.
    #
    # ==== Params
    # _season_:: season for which are games searched.
    #
    # ==== Returns
    # _boolean_:: true when some games had been already drawn, false otherwise.
    private
    def has_some_games(season)
      return @league.games.where(:season => season).count > 0
    end

    # Checks whether competition is already drawn.
    #
    # ==== Params
    # _season_:: season for which will be competition checked.
    #
    # ==== Returns
    # _boolean_:: true when competition id already drawn, false otherwise.
    private
    def is_already_drawn(season)
      return !self.has_some_games(season)
    end
    
    # Checks and returns number of times that should teams in this competition
    # play  each-to-each. When this information is not contained in +type_data+
    # of league, +DEFAULT_LEAGUE_AGAINST+ is returned.
    # 
    # ==== Returns
    # _Integer_:: number of times that should teams in this competition play
    #             each-to-each.
    private
    def get_against_count
      return @league.type_data != nil && @league.type_data[:against] != nil ?
        @league.type_data[:against] :
        DEFAULT_LEAGUE_AGAINST
    end
    
    # Draws competition.
    #
    # Each standard competition consists of several times each-to-each games.
    # All games are defined in link:../../config/games and loaded automatically
    # in initializer.
    #
    # When some games configuration is not found (for number of teams, contained
    # in league), league is not drawn and error is logged. Same situation comes
    # when league had been already drawn for specified season.
    #
    # ==== Params
    # _season_:: season which should be drawn.
    #
    # ==== Returns
    # _boolean_:: true when competition was drawn (Games created), false
    #             otherwise.
    public
    def draw(season)
      # do not draw already drawn leagues
      if !self.is_already_drawn(season)
        teams_orig = @league.teams(season)
        teams_count = teams_orig.count
        
        # if i do not have drawing schema for teams_count, do not draw
        if GAMES[teams_count] != nil
          teams = self.get_shuffeled_teams(teams_orig)
          against = self.get_against_count
          part_rounds = GAMES[teams_count].length
          total_rounds = against * part_rounds
          
          for a in 0..against-1
            for b in 1..part_rounds
              round = (a*part_rounds + b)
              date = DateTime.now + ((round*2)-1).days # TODO better date generator

              for c in 1..GAMES[teams_count][b].length
                home_team = GAMES[teams_count][b][c][a % 2]
                away_team = GAMES[teams_count][b][c][1 - (a % 2)]

                time_array = GAME_START[LEAGUE_TYPE_STANDARD][date.wday]
                time = time_array[round < total_rounds-2 ? rand(time_array.length) : 0] # last 2 rounds have al games same start time - [0] of list of times for specified day
                game_date = date.change({:hour => time[0] , :min => time[1]})

                g = Game.new(
                  :league => league,
                  :season => Params.season,
                  :round => round,
                  :start => game_date,
                  :team_home => teams[home_team].team,
                  :team_away => teams[away_team].team
                )
                g.stadium = self.get_default_stadium_for_game(g)
                g.save
              end
            end
          end
          
          # everything OK
          return true
        else
          Rails.logger.error("unknown teams count (#{teams_count})!")
        end
      else
        Rails.logger.error("competition already drawn for season (#{season})!")
      end
      
      # validation valied (wrong teams count or non existing games config)
      return false
    end
  end
  
  # Drawer class for national cups.
  class ChampionsCupDrawer < CompetitionDrawer
    def draw(season)
      # TODO draw ChampionsCupDrawer
    end
  end
  
  # Drawer class for champions cup and all of its subgroups.
  class NationalCupDrawer < CompetitionDrawer
    def draw(season)
      # TODO draw NationalCupDrawer
    end
  end
  
  # Returns CompetitionDrawer instance depending on league type.
  #
  # ==== Params
  # _league_:: league for which should be drawer created (instance of League). 
  #
  # ==== Returns
  # _CompetitionDrawer_:: drawer depending on league type or nil when
  #                       league_type is unknown/invalid.
  #
  # ==== See
  # LeaguesHelper#CompetitionDrawer
  # LeaguesHelper#StandardLeagueDrawer
  # LeaguesHelper#ChampionsCupDrawer
  # LeaguesHelper#NationalCupDrawer
  def create_drawer(league)
    case league.league_type
    when LEAGUE_TYPE_STANDARD
      return StandardLeagueDrawer.new(league)
    when LEAGUE_TYPE_CUP
      return NationalCupDrawer.new(league)
    when LEAGUE_TYPE_CHAMPIONS_CUP
      return ChampionsCupDrawer.new(league)
    else
      Rails.logger.error "Invalid league type (" + league.league_type.to_s + ")"
      return nil
    end
  end
  
  ##############################################################################
  ##############################################################################
  ##############################################################################
  
  # TODO dat toto do haje, mel bych vse delat pres classy
  
  # Updates teams within standard league. Updating means that when season is not
  # 1 (because for first season teams are just splitted into leagues within
  # migration), all promotions (not relegations! these are done when promotion
  # of league in which team should relegate is called) of this league
  # are realized.
  #
  # ==== Params
  # _league_:: league where promotions shoulf be realized (instance of League).
  # _season_:: number of season, which will follow after teams change.
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
  
  # Sets first round of national cup. It means that all teams of country are put
  # into competition.
  #
  # ==== Params
  # _league_:: league where all teams of its country should be put for following
  #            season (instance of League).
  # _season_:: number of season, which will follow after teams change.
  def update_teams_national_cup(league, season)
    for team in league.country.teams
      LeagueTeam.new(
        :league => league,
        :team => team,
        :season => season
      ).save
    end
  end
  
  # Prepare champions cup for next season.
  # 
  # TODO not implemented yet!
  #
  # ==== Params
  # _league_:: champions cup (instance of League).
  # _season_:: number of season, which will follow after teams change.
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
  
  # Draws league based on its state for presented season. E.g. when standard
  # league hasnt been for this season already drawn, it is drawn now.
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
