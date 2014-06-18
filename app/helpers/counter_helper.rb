include LeaguesHelper

# Additional functions for CounterController.
module CounterHelper
  
  # Prepares day recount. Should be called before any counter function started.
  #
  # ==== Returns
  # _Hash_:: hash of prepared data, containing followinf keys:
  def day_prepare
    ret = {}
    
    return ret
  end
  
  # Finishes day recount. Should be called after all counter functions finished.
  def c_day_finalize
    Params.inc_season_day
  end
  
  # Prepares season recount. Should be called before any counter function
  # started.
  #
  # ==== Returns
  # _Hash_:: hash of prepared data, containing followinf keys:
  #          _competitions_to_draw_:: all competitions that should be drawn
  #                                   during this recount
  def season_prepare
    ret = {
      :competitions_to_draw => League.all
    }
    
    ret[:competitions_to_draw]
    
    return ret
  end

  # Updates structure of league with specified id.
  #
  # ==== Returns
  # _boolean_:: true on success, false otherwise.
  #
  # ==== See
  # LeaguesHelper#update_teams
  def season_update_league_teams(leagueId)
    LeaguesHelper::update_teams(League.find(leagueId), Params.season+1)
    return true
  end
  
  # Draws league with specified id for season + 1 (it means following season to
  # currentlz finished).
  #
  # ==== Returns
  # _boolean_:: true on success, false otherwise.
  #
  # ==== See
  # LeaguesHelper#create_drawer
  def season_draw_league(leagueId)
    LeaguesHelper::draw(League.find(leagueId), Params.season+1)
    return true
  end
  
  # Finishes season recount. Should be called after all counter functions
  # finished.
  def season_finalize
    Params.inc_season
  end
end
