class CreateTacticsPlayers < ActiveRecord::Migration
  def change
    create_table :tactics_players do |t|
      t.references :tactics,    :null => false
      t.references :player,     :null => true, :default => nil
      t.integer :position,      :null => true, :default => nil

      t.timestamps
    end
    
    add_index :tactics_players, :tactics_id
    add_index :tactics_players, :player_id
  end
end
