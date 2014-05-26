class CreateGameActions < ActiveRecord::Migration
  def change
    create_table :game_actions do |t|
      t.references :game,   :null => false
      t.references :action, :null => false
      t.integer :minute,    :null => false
      t.text :data,         :null => false

      t.timestamps
    end
    
    add_index :game_actions, :game_id
    add_index :game_actions, :action_id
  end
end
