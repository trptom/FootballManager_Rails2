class CreateTeamCoefs < ActiveRecord::Migration
  def change
    create_table :team_coefs do |t|
      t.references :team
      t.int :season
      t.decimal :coef

      t.timestamps
    end
    add_index :team_coefs, :team_id
  end
end
