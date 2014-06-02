class CreateTactics < ActiveRecord::Migration
  def change
    create_table :tactics do |t|
      t.references :team,           :null => false
      t.integer :priority,          :null => false, :default => 0
      t.string :name,               :null => false
      t.integer :style,             :null => false, :default => 50
      t.integer :passing,           :null => false, :default => 50
      t.integer :shooting,          :null => false, :default => 50
      t.integer :aggressiveness,    :null => false, :default => 50

      t.timestamps
    end
    
    add_index :tactics, :team_id
  end
end
