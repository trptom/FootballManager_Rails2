class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.references :league,           :null => false
      t.integer :season,              :null => false
      t.integer :round,               :null => true, :default => nil
      t.datetime :start,              :null => false
      t.integer :team_home_id,        :null => false
      t.integer :team_away_id,        :null => false
      t.integer :score_home,          :null => true, :default => nil
      t.integer :score_away,          :null => true, :default => nil
      t.integer :score_half_home,     :null => true, :default => nil
      t.integer :score_half_away,     :null => true, :default => nil
      t.references :stadium,          :null => false
      t.integer :attendance,          :null => true, :default => nil
      t.integer :winner,              :null => true, :default => nil
      t.integer :result_type,         :null => true, :default => nil
      t.boolean :started,             :null => false, :default => false
      t.boolean :finished,            :null => false, :default => false
      t.integer :min,                 :null => true, :default => nil

      t.timestamps
    end
    
    add_index :games, :season
    add_index :games, :league_id
    add_index :games, :team_home_id
    add_index :games, :team_away_id
    add_index :games, :stadium_id
  end
end
