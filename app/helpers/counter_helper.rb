include LeaguesHelper

module CounterHelper
  def day_prepare
    ret = {}
    
    return ret
  end
  
  def c_day_finalize
    Params.inc_season_day
  end
  
  def season_prepare
    ret = {
      :competitions_to_draw => League.all
    }
    
    ret[:competitions_to_draw]
    
    return ret
  end

  def season_update_league_teams(leagueId)
    LeaguesHelper::update_teams(League.find(leagueId), Params.season+1)
    
    return true
  end
  
  def season_draw_league(leagueId)
    
    LeaguesHelper::draw(League.find(leagueId), Params.season+1)
    
    return true
  end
  
  def season_finalize
    Params.inc_season
  end
end
