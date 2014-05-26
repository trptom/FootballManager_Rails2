class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :first_name,   :null => false
      t.string :second_name,  :null => true, :default => nil
      t.string :last_name,    :null => false
      t.string :pseudonym,    :null => true, :default => nil
      t.integer :age,         :null => false
      t.float :gk,            :null => false
      t.float :def,           :null => false
      t.float :mid,           :null => false
      t.float :att,           :null => false
      t.float :shooting,      :null => false
      t.float :passing,       :null => false
      t.float :stamina,       :null => false
      t.float :speed,         :null => false
      t.float :aggresivness,  :null => false
      t.integer :quality,     :null => false
      t.integer :potential,   :null => false
      t.integer :foot,        :null => false
      t.references :country,  :null => false
      t.string :icon,         :null => true, :default => nil

      t.timestamps
    end
    
    add_index :players, :country_id
  end
end
