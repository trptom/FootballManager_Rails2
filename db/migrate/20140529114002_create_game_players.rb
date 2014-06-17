class CreateGamePlayers < ActiveRecord::Migration
  def change
    create_table :game_players do |t|
      t.references :game,     :null => false
      t.references :player,   :null => false
      t.integer :team,        :null => false
      t.integer :position,    :null => true, :default => nil
      t.integer :min_on,      :null => true, :default => nil
      t.integer :min_off,     :null => true, :default => nil
      t.integer :reason_off,  :null => true, :default => nil

      t.timestamps
    end
    
    add_index :game_players, :game_id
    add_index :game_players, :player_id
  end
end
