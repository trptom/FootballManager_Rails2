class CreateCountryCoefs < ActiveRecord::Migration
  def change
    create_table :country_coefs do |t|
      t.references :country,  :null => false
      t.integer :season,      :null => false
      t.decimal :coef,        :null => false, :default => 0

      t.timestamps
    end
    
    add_index :country_coefs, :country_id
    add_index :country_coefs, :season
    
    for c in Country.all
      for s in -5..5
        co = rand(500).to_f / 100.0
        
        CountryCoef.new(
          :country => c,
          :season => s,
          :coef => co
        ).save
      end
    end
  end
end
