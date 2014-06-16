module GamesHelper
  ##############################################################################
  # SIMULATION OF GAME
  ##############################################################################
  
  def prepare(game)
    #create result variable
    res = true
    
    # get tactics for later use
    tactics = [
      game.team_home.get_primary_tactics,
      game.team_away.get_primary_tactics
    ]

    # set game data
    game.transaction do
      # update game to be started
      res = GamesHelper::update_game_atts_to_started(game) && res
      
      # create copy of prefferred team tactics to game
      res = GamesHelper::create_team_tactics(game, 1, tactics[0]) && res
      res = GamesHelper::create_team_tactics(game, 2, tactics[1]) && res
      
      # fill in game_players depending on tactics
      GamesHelper::create_game_players(game, game.team_home, 1, tactics[0])
      GamesHelper::create_game_players(game, game.team_away, 2, tactics[1])
    end
    
    # check whether game can be started
    # TODO game check (at least 7 players, 1 GK, ...)
    
    return res
  end
  
  # Simulates all minutes until now which havent been simulated yet.
  # 
  # game = game which should be simulated
  # 
  # returns: true on success, valse otherwise
  def simulate_previous_minutes(game)
    result = true
    
    last_min = game.min == nil ? 0 : game.min
    current_min = [game.real_min, 90].min

    Rails.logger.info("simulating minutes " + last_min.to_s + ".." + current_min.to_s)

    for a in last_min+1..current_min
      Rails.logger.info("simulating minute " + a.to_s)
      result = game.simulate_minute(a) && result
    end

    game.min = current_min
    
    if current_min == 90
      game.finished = true
    end
    
    return game.save && result
  end
  
  # Simulates goals in game for specified minute. All events and game changes
  # are saved within this function.
  def simulate_goals(game, team_id, minute)
    goal_coef = rand(30+(20*team_id))
    
    if (goal_coef == 0)
      is_penalty = rand(1) == 0
      
      player = is_penalty ?
        GamesHelper::get_penalty_executor(game, team_id) :
        GamesHelper::get_scorer(game, team_id)
      goalkeeper = game.game_players.where(:team => team_id).goalkeepers.first
      
      is_goal = is_penalty ?
        GamesHelper::is_penalty_successfull(player, goalkeeper) :
        GamesHelper::is_shot_successfull(player, goalkeeper, 100) # currently must be always true

      game.transaction do
        GameEvent.new(
          :game_id => game.id,
          :event_type => GAME_EVENT[is_penalty ? (is_goal ? :penalty_yes : :penalty_no) : :goal],
          :player_id => player.id,
          :team => team_id,
          :minute => minute
        ).save

        if is_goal
          GamesHelper::increase_goal(game, team_id, minute)
        end
      end
    end
  end
  
  def simulate_yellow_cards(game, team_id, minute)
    yc_coef = rand(10)
    Rails.logger.info("team " + team_id.to_s + " yc_coef = " + yc_coef.to_s)
    
    if (yc_coef == 0)
      p_id = rand(5)
      players = nil
      case p_id
      when 0
        players = game.game_players.on_pitch.where(:team => team_id)
      else
        players = game.game_players.on_pitch.where("(team = ?)AND(position <> ?)", team_id, POSITION_ID[POSITION_GK])
      end

      Rails.logger.info("team " + team_id.to_s + " playerscount: " + players.count.to_s)
      player = players[rand(players.count)]
      Rails.logger.info("team " + team_id.to_s + " card: " + player.to_s)

      already_booked = GamesHelper::has_card(game, player)
      
      game.transaction do
        # TODO second yellow
        GameEvent.new(
          :game_id => game.id,
          :event_type => GAME_EVENT[already_booked ? :yellow_red : :yellow],
          :player_id => player.player.id,
          :team => team_id,
          :minute => minute
        ).save

        if already_booked
          player.min_off = minute
          player.save
        end
      end
    end
  end
  
  ##############################################################################
  # SIMULATION OF GAME - additional functions
  ##############################################################################
  
  # Updates game attributes to be equal with started game. Game is aldo saved
  # and result of save function is returned!
  def update_game_atts_to_started(game)
    game.started = true
    game.score_home = 0
    game.score_half_home = 0
    game.score_away = 0
    game.score_half_away = 0
    
    return game.save
  end
  
  # Creates new tactics for specified team in game. Tactics is copy of
  # team_tactics param (or default tactics when team_tactics is nil).
  def create_team_tactics(game, team_id, team_tactics)
    if team_tactics != nil
      return GameTactics.new(
        :game_id => game.id,
        :team => team_id,
        :style => team_tactics.style,
        :passing => team_tactics.passing,
        :shooting => team_tactics.shooting,
        :aggressiveness => team_tactics.aggressiveness
      ).save  
    else
      return GameTactics.new(
        :game_id => game.id,
        :team => team_id,
        :style => 50,
        :passing => 50,
        :shooting => 50,
        :aggressiveness => 50 # TODO default values in configuration
      ).save
    end
  end
  
  def create_game_players(game, team, team_id, tactics)
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
          :game_id => game.id,
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
          :game_id => game.id,
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
  def get_scorer(game, team_id)
    players = nil

    # get list of players depending on position
    begin
      pos_type = rand(7)
      case pos_type
      when 0
        players = game.game_players.on_pitch.defenders.where(:team => team_id)
      when 1..2
        players = game.game_players.on_pitch.midfielders.where(:team => team_id)
      when 3..6
        players = game.game_players.on_pitch.attackers.where(:team => team_id)
      end
      
      # log warning when no player
      if players.count == 0
        Rails.logger.info("no player for position of type #{pos_type.to_s}!")
      end
    end while players.count == 0

    # return random player from list
    return players[rand(players.count)]
  end
  
  def get_penalty_executor(game, team_id)
    # TODO executor of penalty should be dependent on tactics
    return GamesHelper::get_scorer(game, team_id)
  end
  
  # Counts if shot of shooter was successfull.
  #
  # shooter: shooter object (instance of GamePlayer).
  # goalkeeper: goalgeeper object (instance of GamePlayer).
  # shot_coef: coefficient of shooting position 1-100 (100 is best from which
  #            all shooters should be in most of cases successfull).
  #
  # returns: true if shooter scored goal, false otherwise.
  def is_shot_successfull(shooter, goalkeeper, shot_coef)
    # TODO is_shot_successfull behaviour
    return true;
  end
  
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
  
  # Incerases goal of specified team in game. When minute <= 45, increases also
  # halftime score. Game is saved afterwards.
  def increase_goal(game, team_id, minute)
    if team_id == 1
      game.score_home = game.score_home + 1
    else
      game.score_away = game.score_away + 1
    end

    if minute <= 45
      if team_id == 1
        game.score_half_home = game.score_half_home + 1
      else
        game.score_half_away = game.score_half_away + 1
      end
    end

    game.save
  end
  
  def has_card(game, player)
    return game.game_events.where(:player_id => player.player.id, :event_type => GAME_EVENT[:yellow]).count > 0
  end
end
