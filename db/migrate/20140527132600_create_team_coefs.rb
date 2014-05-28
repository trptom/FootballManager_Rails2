class CreateTeamCoefs < ActiveRecord::Migration
  def change
    create_table :team_coefs do |t|
      t.references :team,   :null => false
      t.integer :season,    :null => false
      t.decimal :coef,      :null => false, :default => 0

      t.timestamps
    end
    
    add_index :team_coefs, :team_id
    add_index :team_coefs, :season
  end
end
