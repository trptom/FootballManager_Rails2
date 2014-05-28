module PlayersHelper
  ##############################################################################
  # GUESSING (auto generating of attributes)
  ##############################################################################
  
  def guess_country(team)
    if (rand(100) > 95) # small chance to have foreign player
      return Country.offset(rand(Country.count)).first
    else
      return team.country
    end
  end
  
  def guess_name(country)
    # TODO guessing
  end
  
  def guess_age()
    return rand(17..20)
  end
  
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
    return rand(17..20)
  end
  
  def guess_quality(team)
    
  end
  
  def guess_potential(team)
    
  end
  
  def guess_foot
    
  end
  
  def guess_atts(age, quality, potential)
    
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
      :gk => pos[:gk],
      :def => pos[:def],
      :mid => pos[:mid],
      :att => pos[:att],
      :shooting => atts[],
      :passing => atts[],
      :stamina => atts[],
      :speed => atts[],
      :aggresivness => atts[],
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
