include PlayerNamesHelper

class PlayerNamesController < ApplicationController
  def stats
    @first_names = Player.select("first_name, count(first_name) as counter").group(:first_name).order("counter DESC")
    @last_names = Player.select("last_name, count(last_name) as counter").group(:last_name).order("counter DESC")
  end
  
  def update_names
    country = params[:country] ? Country.where(:shortcut => params[:country]).first : nil
    
    @total_before = country ? PlayerName.where(:country_id => country.id).count : PlayerName.count
    
    PlayerNamesHelper::fill_in_names(params[:country] ? params[:country] : nil)
    
    @total_after = country ? PlayerName.where(:country_id => country.id).count : PlayerName.count
  end
end
