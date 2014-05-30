class GamesController < ApplicationController
  def show
    @game = Game.find(params[:id])
    
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
end
