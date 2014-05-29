class CreatePlayerStats < ActiveRecord::Migration
  def change
    create_table :player_stats do |t|
      t.references :player,     :null => false
      t.references :league,     :null => false
      t.integer :season,        :null => false
      t.integer :gp,            :null => false, :default => 0
      t.integer :goals,         :null => false, :default => 0
      t.integer :assists,       :null => false, :default => 0
      t.integer :y_cards,       :null => false, :default => 0
      t.integer :r_cards,       :null => false, :default => 0
      t.decimal :rnk,           :null => false, :default => 0

      t.timestamps
    end
    
    add_index :player_stats, :player_id
    add_index :player_stats, :league_id
    add_index :player_stats, :season
  end
end
