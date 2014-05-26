class CreateStadiumStands < ActiveRecord::Migration
  def change
    create_table :stadium_stands do |t|
      t.references :stadium,  :null => false
      t.integer :location,    :null => false
      t.integer :level,       :null => false, :default => 0
      t.integer :type,        :null => false, :default => 0
      t.float :angle,         :null => false, :default => 20
      t.integer :rows,        :null => false, :default => 10
      t.integer :capacity,    :null => false, :defautl => 0
      t.integer :maintenance, :null => false, :default => 0

      t.timestamps
    end
    
    add_index :stadium_stands, :stadium_id
  end
end
