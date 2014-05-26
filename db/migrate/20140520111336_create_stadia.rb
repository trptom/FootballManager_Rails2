class CreateStadia < ActiveRecord::Migration
  def change
    create_table :stadia do |t|
      t.references :team,   :null => false
      t.string :name,       :null => false

      t.timestamps
    end
    add_index :stadia, :team_id
    
    # TODO vytvareni stadionu nejak inteligentne, tohle je jen aby mi to nechcipalo ze zadnej neexistuje
    for team in Team.all
      Stadium.new({
        :team => team,
        :name => "New stadium"
      }).save
    end
  end
end
