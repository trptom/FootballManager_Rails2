class CreateGameTactics < ActiveRecord::Migration
  def change
    create_table :game_tactics do |t|
      t.references :game,           :null => false
      t.integer :team,              :null => false
      t.integer :style,             :null => false
      t.integer :passing,           :null => false
      t.integer :shooting,          :null => false
      t.integer :aggressiveness,    :null => false

      t.timestamps
    end
    add_index :game_tactics, :game_id
  end
end
