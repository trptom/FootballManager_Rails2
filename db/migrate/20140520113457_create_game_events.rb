class CreateGameEvents < ActiveRecord::Migration
  def change
    create_table :game_events do |t|
      t.references :game,     :null => false
      t.references :player,   :null => false
      t.integer :event_type,  :null => false
      t.integer :team,        :null => true, :default => nil
      t.integer :minute,      :null => false

      t.timestamps
    end
    
    add_index :game_events, :game_id
    add_index :game_events, :player_id
  end
end
