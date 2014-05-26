class CreatePromotions < ActiveRecord::Migration
  def promote(from_id, from_pos, to_id, to_pos, barage)
    Promotion.new(
      :league_from_id => from_id,
      :league_from_pos => from_pos,
      :league_to_id => to_id,
      :league_to_pos => to_pos,
      :barage => barage
    ).save
  end
  
  def set_promotion_2(country)
    @from = League.where(:country_id => country.id, :league_type => LEAGUE_TYPE_STANDARD, :level => 2).first
    @to = League.where(:country_id => country.id, :league_type => LEAGUE_TYPE_STANDARD, :level => 1).first
    
    promote(@from.id, 1, @to.id, @to.league_teams.count, false)
    promote(@from.id, 2, @to.id, @to.league_teams.count-1, true)
  end
  
  def set_promotion_3(country)
    @from = League.where(:country_id => country.id, :league_type => LEAGUE_TYPE_STANDARD, :level => 3).order(:grp)
    @to = League.where(:country_id => country.id, :league_type => LEAGUE_TYPE_STANDARD, :level => 2).first
    
    promote(@from[0].id, 1, @to.id, @to.league_teams.count, false)
    promote(@from[1].id, 1, @to.id, @to.league_teams.count-1, false)
    promote(@from[1].id, 2, @to.id, @to.league_teams.count-2, true)
    promote(@from[0].id, 2, @to.id, @to.league_teams.count-3, true)
  end
  
  def set_promotion_4(country)
    @from = League.where(:country_id => country.id, :league_type => LEAGUE_TYPE_STANDARD, :level => 4).order(:grp)
    @to = League.where(:country_id => country.id, :league_type => LEAGUE_TYPE_STANDARD, :level => 3).order(:grp)
    
    promote(@from[0].id, 1, @to[0].id, @to[0].league_teams.count, false)
    promote(@from[1].id, 1, @to[0].id, @to[0].league_teams.count-1, false)
    promote(@from[1].id, 2, @to[0].id, @to[0].league_teams.count-2, true)
    promote(@from[0].id, 2, @to[0].id, @to[0].league_teams.count-3, true)
    promote(@from[2].id, 1, @to[1].id, @to[1].league_teams.count, false)
    promote(@from[3].id, 1, @to[1].id, @to[1].league_teams.count-1, false)
    promote(@from[3].id, 2, @to[1].id, @to[1].league_teams.count-2, true)
    promote(@from[2].id, 2, @to[1].id, @to[1].league_teams.count-3, true)
  end
  
  def set_promotion_5(country)
    @from = League.where(:country_id => country.id, :league_type => LEAGUE_TYPE_STANDARD, :level => 5).order(:grp)
    @to = League.where(:country_id => country.id, :league_type => LEAGUE_TYPE_STANDARD, :level => 4).order(:grp)
    
    for a in 0..3 do
      promote(@from[a].id, 1, @to[a].id, @to[a].league_teams.count, false)
      promote(@from[a].id, 2, @to[a].id, @to[a].league_teams.count-1, false)
      promote(@from[a].id, 3, @to[a].id, @to[a].league_teams.count-2, true)
    end
  end
  
  def change
    create_table :promotions do |t|
      t.integer :league_from_id,    :null => false
      t.integer :league_from_pos,   :null => false
      t.integer :league_to_id,      :null => false
      t.integer :league_to_pos,     :null => false
      t.boolean :barage,            :null => false, :default => false

      t.timestamps
    end
    
    add_index :promotions, :league_from_id
    add_index :promotions, :league_to_id
    
    for country in Country.all do
      set_promotion_2(country)
      set_promotion_3(country)
      set_promotion_4(country)
      set_promotion_5(country)
    end
  end
end
