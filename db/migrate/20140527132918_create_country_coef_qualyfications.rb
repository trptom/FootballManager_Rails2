class CreateCountryCoefQualyfications < ActiveRecord::Migration
  def change
    create_table :country_coef_qualyfications do |t|
      t.integer :position
      t.integer :teams_champions_cup

      t.timestamps
    end
  end
end
