include CounterHelper

class CounterController < ApplicationController
  def season
    @data = CounterHelper::season_prepare
  end

  def season_update_league_teams
    respond_to do |format|
      format.json {
        render json: {
          :result => CounterHelper::season_update_league_teams(params[:id])
        }
      }
    end
  end
  
  def season_draw_league
    respond_to do |format|
      format.json {
        render json: {
          :result => CounterHelper::season_draw_league(params[:id])
        }
      }
    end
  end

  def day
    @data = CounterHelper::day_prepare
  end
end
