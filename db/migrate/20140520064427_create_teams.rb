class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name,           :null => false
      t.references :user,       :null => true, :default => nil
      t.references :country,    :null => false

      t.timestamps
    end
    
    add_index :teams, :user_id
    add_index :teams, :country_id
  end
end
