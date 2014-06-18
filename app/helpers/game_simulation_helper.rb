# Helper module used to simulating games.
module GameSimulationHelper
  
  # Class used within GameSimulator to store precounted values of team
  # strength, ...
  class TeamStrength
    @game = nil
    @team_id = nil
    
    # Simple initializator for specific game.
    def initialize(game, team_id)
      @game = game
      @team_id = team_id
    end
  end
  
  # Class used to simulate game. New instance should be created for each game.
  class GameSimulator
    @@GAME_DURATION = 90
    @@OVERTIME_DURATION = 30 # TODO not implemented yet
    @@GOLDEN_GOAL = false # TODO not used - needs to be implemented
    
    @@COEF_GOAL = 40
    @@COEF_GOAL_AWAY_DISADVANTAGE = 20
    
    # How often should be penalty kicked instead of goal? 1=always, 2=50%
    # chance, ...
    @@COEF_PENALTY = 7
    
    # How often should be somebody booked? 1=each minute should be booked one
    # player of each team, ...
    @@COEF_YELLOW_CARD = 35
    
    # How often should be somebody booked? 1=each minute should be booked one
    # player of each team, ...
    @@COEF_RED_CARD = 300
    
    # How often should be somebody injured? 1=each minute should be injured one
    # player of each team, ...
    @@COEF_INJURY = 150
    
    # Percentage chance of light injury if some player was injured. Should be
    # 1..100.
    @@LIGHT_INJURY_CHANCE = 50
    
    # Minimum players of team. When lower number raised, game is finished.
    @@MIN_PLAYERS = 7
    
    # Score of team who wins by forfeit. Second team will have score 0.
    @@FORFEIT_WINNER_SCORE = 3
    
    @game = nil
    @strength = nil
    
    # Simple initializator for specific game.
    # 
    # ==== Attributes
    # _game_:: game associated with this simulator.
    def initialize(game)
      @game = game
    end
    
    # Prepares game to can be started.
    #
    # - tactics are created
    # - game-player relations are created
    # - attributes like started and score are changed
    #
    # This function has no restrictions and controls (e.g. whether game
    # was already prepared) so be careful with using it.
    #
    # ==== Returns
    # _boolean_:: True on success, false when error occured.
    def prepare
      #create result variable
      res = true
      # get tactics for later use
      tactics = [
        @game.team_home.get_primary_tactics,
        @game.team_away.get_primary_tactics
      ]

      # set game data
      @game.transaction do
        # update game to be started
        res = self.update_game_atts_to_started && res

        # create copy of prefferred team tactics to game
        res = self.create_team_tactics(1, tactics[0]) && res
        res = self.create_team_tactics(2, tactics[1]) && res

        # fill in game_players depending on tactics
        self.create_game_players(@game.team_home, 1, tactics[0])
        self.create_game_players(@game.team_away, 2, tactics[1])
      end

      # check whether team has still enough of players, goalkeepers, ...
      if self.check_and_forfeit
        # when not forfeited, recount strengths
        self.count_strengths
      end

      return res
    end
    
    # Simulates all minutes until now which havent been simulated yet. When
    # game is already finished (e.g. forfeit), nothing is simulated.
    # 
    # ==== Returns
    # _boolean_:: True on success, false otherwise.
    def simulate_previous_minutes
      # simulate just when game has not finished status
      if !@game.finished
        result = true

        last_min = @game.min == nil ? 0 : @game.min
        current_min = [@game.real_min, @@GAME_DURATION].min

        for a in last_min+1..current_min
          if !@game.finished # just when not finished - gaem can be forfeited
            result = self.simulate_minute(a) && result
            @game.min = a
          end
        end

        if current_min == @@GAME_DURATION
          @game.finished = true
        end

        return @game.save && result
      else
        return true
      end
    end
    
    # Simulates one minute of game. This simulation has no restrictions and
    # controls (e.g. whether game is started and this minute was already
    # simulated) so be careful with using it.
    # 
    # ==== Attributes
    # _minute_:: minute which should be simulated.
    #
    # ==== Returns
    # _boolean_:: Result of simulation (true/false on error).
    def simulate_minute(minute)
      res = true

      for team_id in 1..2
        # GOALS
        res = self.simulate_goals(team_id, minute) && res

        # YELLOW CARDS
        res = self.simulate_yellow_cards(team_id, minute) && res
        
        # RED CARDS
        res = self.simulate_red_cards(team_id, minute) && res
        
        # INJURIES
        res = self.simulate_injuries(team_id, minute) && res
      end

      return res
    end
    
    # Simulates goals in game for specified minute. All events and game changes
    # are saved within this function.
    #
    # ==== Attributes
    # _team_id_:: id of team for which are goals simulated. 1 for home, 2 for
    #             away.
    # _minute_:: minute for which are goals simulated and if some team scores
    #            goal, its event has this minute.
    private
    def simulate_goals(team_id, minute)
      goal_coef = rand(@@COEF_GOAL + (@@COEF_GOAL_AWAY_DISADVANTAGE * (team_id - 1)))
      
      if (goal_coef == 0)
        is_penalty = rand(@@COEF_PENALTY) == 0

        player = is_penalty ?
          self.get_penalty_executor(team_id) :
          self.get_scorer(team_id)
        goalkeeper = @game.game_players.where(:team => team_id).goalkeepers.first

        is_goal = is_penalty ?
          self.is_penalty_successfull(player, goalkeeper) :
          self.is_shot_successfull(player, goalkeeper, 100) # currently must be always true

        @game.transaction do
          GameEvent.new(
            :game_id => @game.id,
            :event_type => GAME_EVENT[is_penalty ? (is_goal ? :penalty_yes : :penalty_no) : :goal],
            :player_id => player.player.id,
            :team => team_id,
            :minute => minute
          ).save

          if is_goal
            self.increase_goal(team_id, minute)
          end
        end
      end
    end
    
    # Simulates yellow cards in game for specified minute. All events and game
    # changes are saved within this function.
    #
    # ==== Attributes
    # _team_id_:: id of team for which are cards simulated. 1 for home, 2 for
    #             away.
    # _minute_:: minute for which are cards simulated and if some player
    #            receives card, its event has this minute.
    private
    def simulate_yellow_cards(team_id, minute)
      booked = rand(@@COEF_YELLOW_CARD) == 0

      if booked
        p_id = rand(5)
        players = nil
        case p_id
        when 0
          players = @game.game_players.on_pitch.where(:team => team_id)
        else
          players = @game.game_players.on_pitch.where("(team = ?)AND(position <> ?)", team_id, POSITION_ID[POSITION_GK])
        end
        
        player = players[rand(players.count)]
        already_booked = self.has_card(player)

        # TODO red cards also for goalkeepers
        if (!already_booked || player.position != POSITION_ID[POSITION_GK]) # currently GK cannot get red card
          @game.transaction do
            GameEvent.new(
              :game_id => @game.id,
              :event_type => GAME_EVENT[already_booked ? :yellow_red : :yellow],
              :player_id => player.player.id,
              :team => team_id,
              :minute => minute
            ).save

            if already_booked
              player.min_off = minute
              player.reason_off = OFF_REASON[:second_yellow]
              player.save
              
              # check whether team has still enough of players, goalkeepers, ...
              if self.check_and_forfeit
                # when not forfeited, recount strengths
                self.count_strengths
              end
            end
          end
        end
      end
    end
    
    # Simulates red cards in game for specified minute. All events and game
    # changes are saved within this function.
    #
    # ==== Attributes
    # _team_id_:: id of team for which are cards simulated. 1 for home, 2 for
    #             away.
    # _minute_:: minute for which are cards simulated and if some player
    #            receives card, its event has this minute.
    private
    def simulate_red_cards(team_id, minute)
      booked = rand(@@COEF_RED_CARD) == 0
      
      if booked
        # TODO possibility to put red card to goalkeeper
        players = @game.game_players.on_pitch.where("(team = ?)AND(position <> ?)", team_id, POSITION_ID[POSITION_GK])
        player = players[rand(players.count)]
        
        @game.transaction do
          GameEvent.new(
            :game_id => @game.id,
            :event_type => GAME_EVENT[:red],
            :player_id => player.player.id,
            :team => team_id,
            :minute => minute
          ).save
          
          player.min_off = minute
          player.reason_off = OFF_REASON[:red]
          player.save
          
          # check whether team has still enough of players, goalkeepers, ...
          if self.check_and_forfeit
            # when not forfeited, recount strengths
            self.count_strengths
          end
        end
      end
    end
    
    # Simulates injuries in game for specified minute. All events and game
    # changes are saved within this function.
    #
    # ==== Attributes
    # _team_id_:: id of team for which are injuries simulated. 1 for home, 2 for
    #             away.
    # _minute_:: minute for which are cards simulated and if some player
    #            injures, its event has this minute.
    private
    def simulate_injuries(team_id, minute)
      injured = rand(@@COEF_INJURY) == 0
      
      if injured
        # TODO possibility to injure goalkeeper
        players = @game.game_players.on_pitch.where("(team = ?)AND(position <> ?)", team_id, POSITION_ID[POSITION_GK])
        player = players[rand(players.count)]
        
        @game.transaction do
          GameEvent.new(
            :game_id => @game.id,
            :event_type => GAME_EVENT[:injury],
            :player_id => player.player.id,
            :team => team_id,
            :minute => minute
          ).save
          
          player.min_off = minute
          player.reason_off = OFF_REASON[:injury]
          player.save
          
          # check whether team has still enough of players, goalkeepers, ...
          if self.check_and_forfeit
            # when not forfeited, recount strengths
            self.count_strengths
          end
        end
      end
    end
    
    # Forfeits game.
    # 
    # ==== Attributes
    # _winner_team_id_:: id of team which wins by forfeit. When nill, game is
    #                    tied (both teams have score 0). Nil by default.
    #
    # ==== Returns
    # _boolean_:: Status of updating game (true/false depending on save result).
    def forfeit(winner_team_id = nil)
      if winner_team_id == nil
        @game.score_home = 0;
        @game.score_away = 0;
        @game.finished = true;
        @game.result_type = GAME_RESULT_TYPE[:forfeit]
        
        return @game.save
      else
        @game.finished = true;
        @game.result_type = GAME_RESULT_TYPE[:forfeit]
        
        if winner_team_id == 1
          @game.score_home = @@FORFEIT_WINNER_SCORE;
          @game.score_away = 0;
        else
          @game.score_home = 0;
          @game.score_away = @@FORFEIT_WINNER_SCORE;
        end
        
        return @game.save
      end
    end
    
    ############################################################################
    # SIMULATION OF GAME - additional functions
    ############################################################################

    # Checks whether both teams matches all conditions. If not, game is
    # forfeited and finished.
    #
    # ==== Returns
    # _boolean_:: false if game was forfeited, true otherwise.
    private
    def check_and_forfeit
      status = []
      for team_id in 1..2
        status[team_id] =
          check_players_count(team_id) &&
          check_goalkeeper_presence(team_id)
      end
      
      if (!status[1] && !status[2])
        self.forfeit
        return false
      end
      
      if !status[1]
        self.forfeit(2)
        return false
      end
      
      if !status[2]
        self.forfeit(1)
        return false
      end
      
      return true
    end
    
    # Checks whether team has goalkeeper within its squad.
    #
    # ==== Attributes
    # _team_id_:: id of team for which should be goalkeepers count checked.
    #             1 for home, 2 for away.
    #
    # ==== Returns
    # _boolean_:: true when goalkeeper is presented, false otherwise.
    private
    def check_goalkeeper_presence(team_id)
      return @game.game_players.on_pitch.where(:team => team_id).goalkeepers.count > 0
    end
    
    # Checks whether team has at least @@MIN_PLAYERS players.
    #
    # ==== Attributes
    # _team_id_:: id of team for which should be players count checked. 1 for
    #             home, 2 for away.
    #
    # ==== Returns
    # _boolean_:: true when team has enough players, false otherwise.
    private
    def check_players_count(team_id)
      return @game.game_players.on_pitch.where(:team => team_id).count >= @@MIN_PLAYERS
    end
    
    # This method recounts team strengths from its current squads. Keep in mind
    # that chances for scoring goals, yellow cards, ... are taken from
    # precounted strengths so if you change squads, you should also recount
    # strangths (call this function). Otherwise you will not affect match
    # by change you made until <i>count_strengths</i> is called.
    private
    def count_strengths
      @strength = {
        :home => TeamStrength.new(@game, 1),
        :away => TeamStrength.new(@game, 2)
      }
    end
    
    # Updates game attributes to be equal with started game. Game is aldo saved
    # and result of save function is returned!
    #
    # ==== Returns
    # _boolean_:: true on success, false otherwise.
    private
    def update_game_atts_to_started
      @game.started = true
      @game.score_home = 0
      @game.score_half_home = 0
      @game.score_away = 0
      @game.score_half_away = 0

      return @game.save
    end

    # Creates new tactics for specified team in game. Tactics is copy of
    # team_tactics param (or default tactics when team_tactics is nil).
    #
    # ==== Attributes
    # _team_id_:: id of team for which should be tectics simulated. 1 for home,
    #             2 for away.
    # _team_tactics_:: tactics from which is new TeamTactics derrived. When
    #                  +nil+, default tactics is used (depending on default
    #                  game tactics configuration).
    #
    # ==== Returns
    # _boolean_:: true on success, false otherwise.
    private
    def create_team_tactics(team_id, team_tactics = nil)
      if team_tactics != nil
        return GameTactics.new(
          :game_id => @game.id,
          :team => team_id,
          :style => team_tactics.style,
          :passing => team_tactics.passing,
          :shooting => team_tactics.shooting,
          :aggressiveness => team_tactics.aggressiveness
        ).save  
      else
        return GameTactics.new(
          :game_id => @game.id,
          :team => team_id,
          :style => 50,
          :passing => 50,
          :shooting => 50,
          :aggressiveness => 50 # TODO default values in configuration
        ).save
      end
    end

    # Creates relations game-player based on currently used tactics. When
    # no tactics is created for specified team, default tactics is used
    # (counted). This us useful mainly for teams without manager.
    #
    # ==== Attributes
    # _team_:: instance of Team vrom which should be players taken when tactics
    #          is not presented.
    # _team_id_:: id of team for which should be GamePlayers created. 1 for
    #             home, 2 for away.
    # _tactics_:: tactics is used to set up correct player positions. Should be
    #             +nil+ or instance of Tactics. When +nil+, default lineup is
    #             created depending on squad of _team_ and default lineup
    #             configuration.
    #
    # ==== Returns
    # _boolean_:: true on success, false otherwise.
    private
    def create_game_players(team, team_id, tactics = nil)
      res = true

      if tactics == nil
        players = team.get_splitted_squad
        Rails.logger.info ("auto loaded players = " + players.to_s)

        squad = [ # TODO better squad generation, this could crash when not enough of players for specific position
          players[PLAYER_POSITION_GK][0],
          players[PLAYER_POSITION_D][0],
          players[PLAYER_POSITION_D][1],
          players[PLAYER_POSITION_D][2],
          players[PLAYER_POSITION_D][3],
          players[PLAYER_POSITION_M][0],
          players[PLAYER_POSITION_M][1],
          players[PLAYER_POSITION_M][2],
          players[PLAYER_POSITION_M][3],
          players[PLAYER_POSITION_S][0],
          players[PLAYER_POSITION_S][1],
        ]
        # TODO fill-in SUB

        for a in 0..10
          res =  GamePlayer.new(
            :game_id => @game.id,
            :player_id => squad[a].id,
            :min_on => 0,
            :min_off => nil,
            :position => LINEUPS[0][:positions][a],
            :team => team_id
          ).save && res
        end
      else
        players = tactics.tactics_players.order(:position)

        for tp in players
          res = GamePlayer.new(
            :game_id => @game.id,
            :player_id => tp.player_id,
            :min_on => tp.position == POSITION_ID[POSITION_SUB] ? nil : tp.position,
            :min_off => nil,
            :position => tp.position,
            :team => team_id
          ).save && res
        end
      end

      return res
    end
    
  
    # Gets random player who scored goal for specified team. Most often its
    # striker. Its never goalkeeper.
    #
    # ==== Attributes
    # _team_id_:: id of team from which should be scorer. 1 for home, 2 for
    #             away.
    #
    # ==== Returns
    # _GamePlayer_:: instance of player, who scored goal.
    private
    def get_scorer(team_id)
      players = nil

      # get list of players depending on position
      begin
        pos_type = rand(7)
        case pos_type
        when 0
          players = @game.game_players.on_pitch.defenders.where(:team => team_id)
        when 1..2
          players = @game.game_players.on_pitch.midfielders.where(:team => team_id)
        when 3..6
          players = @game.game_players.on_pitch.attackers.where(:team => team_id)
        end

        # log warning when no player
        if players.count == 0
          Rails.logger.info("no player for position of type #{pos_type.to_s}!")
        end
      end while players.count == 0

      # return random player from list
      return players[rand(players.count)]
    end

    # Counts penalty executor based on squad attributes and tactics settings.
    #
    # ==== Attributes
    # _team_id_:: id of team from which should be player. 1 for home, 2 for
    #             away.
    #
    # ==== Returns
    # _GamePlayer_:: instance of player, who should be penalty executor.
    private
    def get_penalty_executor(team_id)
      # TODO executor of penalty should be dependent on tactics
      return self.get_scorer(team_id)
    end

    # Counts if shot of shooter was successfull.
    #
    # ==== Attributes
    # _shooter_:: shooter object (instance of GamePlayer).
    # _goalkeeper_:: goalgeeper object (instance of GamePlayer).
    # _shot_coef_:: coefficient of shooting position 1-100 (100 is best from
    #               which all shooters should be in most of cases successfull).
    #
    # ==== Returns
    # _boolean_:: true if shooter scored goal, false otherwise.
    private
    def is_shot_successfull(shooter, goalkeeper, shot_coef)
      # TODO is_shot_successfull behaviour
      return true;
    end

    # Says if player was successfull on penalty, based on his and goalkeepers
    # attributes. Result is random-based so it can have different results
    # for same data.
    #
    # ==== Attributes
    # _shooter_:: instance of GamePlayer.
    # _goalkeeper_:: instance of GamePlayer.
    #
    # ==== Returns
    # _boolean_:: true when shooter was successfull (scored goal), false otherwise.
    private
    def is_penalty_successfull(shooter, goalkeeper)
      # TODO toto neni FM - atributy muzou byt vyssi nez 20, je treba to prekopat
      gk_skill = (goalkeeper.player.speed * goalkeeper.player.gk) / 200.0
      att_skill = shooter.player.shooting
      Rails.logger.info("GK skils: #{gk_skill}; ATT skills: #{att_skill}")

      if gk_skill < 1
        if att_skill < 1
          # both really bad - return random success
          return rand(3) > 0
        else
          # goalkeeper really bad - biggest chance to score
          return rand(20) > 0
        end
      else
        if att_skill < 1
          # attacker really bad - smallest chance to score
          return rand(3) == 2
        else
          # both have normal quality - count
          coef = att_skill - gk_skill
          Rails.logger.info("penalty coef: " + coef.to_s)

          if coef < 0
            # goalkeeper much better - just 50% chance to score
            return rand(2) > 0
          else
            coef = coef.round
            coef = [3, coef].max
            coef = [10, coef].min
            return rand(coef) > 0
          end
        end
      end
    end

    # Incerases goal of specified team in game. When minute <= 45, increases
    # also halftime score. Game is saved afterwards.
    #
    # ==== Attributes
    # _team_id_:: id of team for which should be goal increased. 1 for home,
    #             2 for away.
    # _minute_:: minute when goal was scored - when <= 45 also halftime score is
    #            increased.
    #
    # ==== Returns
    # _boolean_:: true on success, false otherwise.
    private
    def increase_goal(team_id, minute)
      if team_id == 1
        @game.score_home = @game.score_home + 1
      else
        @game.score_away = @game.score_away + 1
      end

      if minute <= 45
        if team_id == 1
          @game.score_half_home = @game.score_half_home + 1
        else
          @game.score_half_away = @game.score_half_away + 1
        end
      end

      @game.save
    end

    # Determines whether player was already booked or not.
    #
    # ==== Attributes
    # _player_:: instance of GamePlayer.
    #
    # ==== Returns
    # _boolean_:: true if player has already been booked, false otherwise.
    private
    def has_card(player)
      return @game.game_events.where(
        :player_id => player.player.id,
        :event_type => GAME_EVENT[:yellow]
      ).count > 0
    end
  end
end