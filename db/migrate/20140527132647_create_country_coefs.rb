class CreateCountryCoefs < ActiveRecord::Migration
  def change
    create_table :country_coefs do |t|
      t.references :country
      t.int :season
      t.decimal :coef

      t.timestamps
    end
    add_index :country_coefs, :country_id
  end
end
