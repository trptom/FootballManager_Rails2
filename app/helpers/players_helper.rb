# Helper module for working with players.
module PlayersHelper
  ##############################################################################
  # GUESSING (auto generating of attributes)
  ##############################################################################
  
  # Automatically generates country for new player in _team_. Usually it is
  # team's country but sometimes it can be different.
  #
  # ==== Params
  # _team_:: team for which player will be created.
  #
  # ==== Returns
  # _Country_:: country for player.
  def guess_country(team)
    if (rand(100) > 95) # small chance to have foreign player
      return Country.offset(rand(Country.count)).first
    else
      return team.country
    end
  end
  
  # Automatically generates name of player from PlayerName configuration
  # in database for specific country.
  #
  # ==== Params
  # _country_:: country associated with name (different names for czechs,
  #             germans, ...).
  #
  # ==== Returns
  # _Hash_:: hash containing parts of name:
  #          _first_name_:: First name of player (e.g. Karel for CZE). Cant be
  #                         nil.
  #          _second_name_:: Second name of player (e.g. Matous for CZE). Can be
  #                          (and usually is) nil.
  #          _last_name_:: Last name of player (e.g. Novak for CZE). Cant be
  #                        nil.
  #          _pseudonym_:: pseudonym of player (e.g. Marzihno for BRA). Can be
  #                        (and usually is) nil.
  def guess_name(country)
    first_names = nil
    last_names = nil
    
    rnd_first = rand(NAME_FREQUENCY_MAX)
    rnd_last = rand(NAME_FREQUENCY_MAX)
    
    first_names = PlayerName.first_names_c(country).where("frequency > ?", rnd_first)
    last_names = PlayerName.last_names_c(country).where("frequency > ?", rnd_last)
    
    return {
      :first_name => first_names.offset(rand(first_names.count)).first.name_str,
      :second_name => nil,
      :last_name => last_names.offset(rand(last_names.count)).first.name_str,
      :pseudonym => nil
    }
  end
  
  # Automatically generates age for new player. Currently is just for young
  # players (coming from youth) in range 17..20.
  #
  # ==== Returns
  # _Integer_:: age for new pleyer.
  def guess_age()
    return rand(17..20)
  end
  
  # Automatically generates position strength for new player (GK/D/M/A;
  # range 1-100). There is always one prefferred position which is automatically
  # chosen depending on +TEAM_REFILL_PLAYERS_POS_TO+ configuration. It means
  # that there will be created more defenders than goalkeepers and so on.
  #
  # ==== Returns
  # _Hash_:: hash of position strengths, containing following fields:
  #          +PLAYER_POSITION_GK+:: goalkeeping strength (1-100).
  #          +PLAYER_POSITION_D+:: defending strength (1-100).
  #          +PLAYER_POSITION_M+:: midfielding strength (1-100).
  #          +PLAYER_POSITION_S+:: attacking strength (1-100).
  def guess_pos()
    sum = TEAM_REFILL_PLAYERS_POS_TO[PLAYER_POSITION_GK]
        + TEAM_REFILL_PLAYERS_POS_TO[PLAYER_POSITION_D]
        + TEAM_REFILL_PLAYERS_POS_TO[PLAYER_POSITION_M]
        + TEAM_REFILL_PLAYERS_POS_TO[PLAYER_POSITION_S]
    pos = rand(1..sum)
    ret = {
      PLAYER_POSITION_GK => 0,
      PLAYER_POSITION_D => 0,
      PLAYER_POSITION_M => 0,
      PLAYER_POSITION_S => 0
    }
    
    if pos <= TEAM_REFILL_PLAYERS_POS_TO[PLAYER_POSITION_GK]
      ret[PLAYER_POSITION_GK] = PLAYER_POSITION_MAX
    elsif pos <= TEAM_REFILL_PLAYERS_POS_TO[PLAYER_POSITION_GK]
        + TEAM_REFILL_PLAYERS_POS_TO[PLAYER_POSITION_D]
      ret[PLAYER_POSITION_D] = PLAYER_POSITION_MAX
    elsif pos <= TEAM_REFILL_PLAYERS_POS_TO[PLAYER_POSITION_GK]
        + TEAM_REFILL_PLAYERS_POS_TO[PLAYER_POSITION_D]
        + TEAM_REFILL_PLAYERS_POS_TO[PLAYER_POSITION_M]
      ret[PLAYER_POSITION_M] = PLAYER_POSITION_MAX
    else
      ret[PLAYER_POSITION_S] = PLAYER_POSITION_MAX
    end
    
    return ret
  end
  
  def guess_quality(team)
    return rand(100)+1
  end
  
  def guess_potential(team)
    return rand(100)+1
  end
  
  def guess_foot
    return rand(5)-2
  end
  
  def guess_atts(age, quality, potential)
    return {
      :shooting => (rand(16) + 10),
      :passing => (rand(16) + 10),
      :stamina => (rand(16) + 10),
      :speed => (rand(16) + 10),
      :aggresivness => (rand(16) + 10)
    }
  end
  
  ##############################################################################
  ## PLAYER CREATORS
  ##############################################################################
  
  def create_player(name, team, country, age, pos, atts, quality, potential, foot)
    if country == nil
      country = PlayersHelper::guess_country(team)
    end
    
    if name == nil
      name = PlayersHelper::guess_name(country)
    end
    
    if age == nil
      age = PlayersHelper::guess_age()
    end
    
    if pos == nil
      pos = PlayersHelper::guess_pos()
    elsif pos == PLAYER_POSITION_GK
      pos = {
        PLAYER_POSITION_GK => PLAYER_POSITION_MAX,
        PLAYER_POSITION_D => 0,
        PLAYER_POSITION_M => 0,
        PLAYER_POSITION_S => 0
      }
    elsif pos == PLAYER_POSITION_D
      pos = {
        PLAYER_POSITION_GK => 0,
        PLAYER_POSITION_D => PLAYER_POSITION_MAX,
        PLAYER_POSITION_M => 0,
        PLAYER_POSITION_S => 0
      }
    elsif pos == PLAYER_POSITION_M
      pos = {
        PLAYER_POSITION_GK => 0,
        PLAYER_POSITION_D => 0,
        PLAYER_POSITION_M => PLAYER_POSITION_MAX,
        PLAYER_POSITION_S => 0
      }
    elsif pos == PLAYER_POSITION_S
      pos = {
        PLAYER_POSITION_GK => 0,
        PLAYER_POSITION_D => 0,
        PLAYER_POSITION_M => 0,
        PLAYER_POSITION_S => PLAYER_POSITION_MAX
      }
    end

    if quality == nil
      quality = PlayersHelper::guess_quality(team)
    end
    
    if potential == nil
      potential = PlayersHelper::guess_potential(team)
    end
    
    if foot == nil
      foot = PlayersHelper::guess_foot()
    end
    
    if atts == nil
      atts = PlayersHelper::guess_atts(age, quality, potential)
    end
    
    return Player.new(
      :first_name => name[:first_name],
      :second_name => name[:second_name],
      :last_name => name[:last_name],
      :pseudonym => name[:pseudonym],
      :age => age,
      :gk => pos[PLAYER_POSITION_GK],
      :deff => pos[PLAYER_POSITION_D],
      :mid => pos[PLAYER_POSITION_M],
      :att => pos[PLAYER_POSITION_S],
      :shooting => atts[:shooting],
      :passing => atts[:passing],
      :stamina => atts[:stamina],
      :speed => atts[:speed],
      :aggresivness => atts[:aggresivness],
      :quality => quality,
      :potential => potential,
      :foot => foot,
      :country => country,
      :team => team,
      :icon => nil
    )
  end
  
  def generate_goalkeeper(team)
    p = PlayersHelper::create_player(nil, team, nil, nil, PLAYER_POSITION_GK, nil, nil, nil, nil)
    p.save
  end
  
  def generate_defender(team)
    p = PlayersHelper::create_player(nil, team, nil, nil, PLAYER_POSITION_D, nil, nil, nil, nil)
    p.save
  end
  
  def generate_midfielder(team)
    p = PlayersHelper::create_player(nil, team, nil, nil, PLAYER_POSITION_M, nil, nil, nil, nil)
    p.save
  end
  
  def generate_attacker(team)
    p = PlayersHelper::create_player(nil, team, nil, nil, PLAYER_POSITION_S, nil, nil, nil, nil)
    p.save
  end
  
  def generate_random(team)
    p = PlayersHelper::create_player(nil, team, nil, nil, nil, nil, nil, nil, nil)
    p.save
  end
end
