class GamesController < ApplicationController
  def show
    @game = Game.find(params[:id])
    
    @events = {
      :home => @game.game_events.where(:team => 1),
      :away => @game.game_events.where(:team => 2)
    }
    @events_length = [@events[:home].count, @events[:away].count].max
    
    @squad = {
      :home => @game.home_players_on,
      :away => @game.away_players_on
    }
    @squad_length = [@squad[:home].count, @squad[:away].count].max
    
    @substitutes = {
      :home => @game.home_players_off,
      :away => @game.away_players_off
    }
    @substitutes_length = [@substitutes[:home].count, @substitutes[:away].count].max
  end
  
  def simulate
    @game = Game.where(:started => false).order(:start).first
    
    @game.simulate
  end
end
