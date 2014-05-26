class CreateLeagueTeams < ActiveRecord::Migration
  @@team_counter = 1
  
  def add_team(league, country)
    @t = Team.new(
      :name => "Team #" + @@team_counter.to_s,
      :user_id => nil,
      :country_id => country.id
    )
    @t.save
    
    LeagueTeam.new(
      :team_id => @t.id,
      :league_id => league.id,
      :season => 1
    ).save
    
    @@team_counter = @@team_counter + 1
  end
  
  def change
    create_table :league_teams do |t|
      t.references :league,         :null => false
      t.references :team,           :null => false
      t.integer :season,            :null => false
      t.integer :gp,                :null => false, :default => 0
      t.integer :w,                 :null => false, :default => 0
      t.integer :wot,               :null => false, :default => 0
      t.integer :t,                 :null => false, :default => 0
      t.integer :lot,               :null => false, :default => 0
      t.integer :l,                 :null => false, :default => 0
      t.integer :gf,                :null => false, :default => 0
      t.integer :ga,                :null => false, :default => 0
      t.integer :gdiff,             :null => false, :default => 0
      t.integer :pts,               :null => false, :default => 0
      t.boolean :stays_in_league,   :null => false, :default => true
      t.text :note,                 :null => true, :default => nil

      t.timestamps
    end
    
    add_index :league_teams, :league_id
    add_index :league_teams, :team_id
    add_index :league_teams, :season
    
    for country in Country.all do
      for league in country.leagues.where(:league_type => LEAGUE_TYPE_STANDARD).order(:level).all
        for team_id in 1..18 do
          add_team(league, country)
        end
      end
    end
  end
end
