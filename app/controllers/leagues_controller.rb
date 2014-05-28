class LeaguesController < ApplicationController
  def coefficients
    @coefs = CountryCoef.ordered_by_sum(Params.season-5, Params.season-1)
  end
  
  def show
    @league = League.find(params[:id])
    @league_teams = []
    @games = {
      :previous => Game.previous_by_league(@league),
      :current => Game.current_by_league(@league),
      :next => Game.next_by_league(@league)
    }
    
    for league in @league.league_teams
      @league_teams << {
        :data => league,
        :style => ""
      }
    end
    
    for promotion in @league.promotions
      if promotion.barage
        @league_teams[promotion.league_from_pos-1][:style] = "promotion barage"
      else
        @league_teams[promotion.league_from_pos-1][:style] = "promotion"
      end
    end

    for relegation in @league.relegations
      logger.info "relegation - " + relegation.league_to_pos.to_s
      if relegation.barage
        @league_teams[relegation.league_to_pos-1][:style] = "relegation barage"
      else
        @league_teams[relegation.league_to_pos-1][:style] = "relegation"
      end
    end
    
    case @league.league_type
    when LEAGUE_TYPE_STANDARD
      render "show_league"
    when LEAGUE_TYPE_CUP
      render "show_national_cup"
    when LEAGUE_TYPE_CHAMPIONS_CUP
      render "show_champions_cup"
    end
  end
end
