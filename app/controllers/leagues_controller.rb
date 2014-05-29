class LeaguesController < ApplicationController
  def coefficients
    @coefs = CountryCoef.ordered_by_sum(Params.season-5, Params.season-1)
  end
  
  def show
    @league = League.find(params[:id])
    @games = {
      :previous => Game.previous_by_league(@league),
      :current => Game.current_by_league(@league),
      :next => Game.next_by_league(@league)
    }
    @games_count = {
      :previous => [@games[:previous].count, @league.league_teams.count/2].min,
      :current => @games[:current].count,
      :next => [@games[:next].count, @league.league_teams.count/2].min
    }
    
    case @league.league_type
    when LEAGUE_TYPE_STANDARD
      @league_teams = []

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
      
      render "show_league"
    when LEAGUE_TYPE_CUP
      render "show_national_cup"
    when LEAGUE_TYPE_CHAMPIONS_CUP
      case @league.level
      when 0 # full overview
        @quals = League.champions_cup_quals
        @groups = League.champions_cup_groups
        @po = League.champions_cup_playoff
        
        render "show_champions_cup"
      when 1 # qualyfication
      when 2 # group stage
      when 3 # play off
      end
    end
  end
  
  def games
    @league = League.find(params[:id])
    @games = {
      :previous => Game.previous_by_league(@league),
      :current => Game.current_by_league(@league),
      :next => Game.next_by_league(@league)
    }
  end
end
