class CreateCountryCoefQualyfications < ActiveRecord::Migration
  def change
    create_table :country_coef_qualyfications do |t|
      t.integer :position,              :null => false, :unique => true
      t.integer :teams_champions_cup,   :null => false, :default => 0

      t.timestamps
    end
    
    CountryCoefQualyfication.new(:position => 1, :teams_champions_cup => 4).save
    CountryCoefQualyfication.new(:position => 2, :teams_champions_cup => 4).save
    CountryCoefQualyfication.new(:position => 3, :teams_champions_cup => 3).save
    CountryCoefQualyfication.new(:position => 4, :teams_champions_cup => 3).save
    CountryCoefQualyfication.new(:position => 5, :teams_champions_cup => 3).save
    CountryCoefQualyfication.new(:position => 6, :teams_champions_cup => 3).save
    CountryCoefQualyfication.new(:position => 7, :teams_champions_cup => 2).save
    CountryCoefQualyfication.new(:position => 8, :teams_champions_cup => 2).save
    CountryCoefQualyfication.new(:position => 9, :teams_champions_cup => 2).save
    CountryCoefQualyfication.new(:position => 10, :teams_champions_cup => 2).save
    CountryCoefQualyfication.new(:position => 11, :teams_champions_cup => 1).save
    CountryCoefQualyfication.new(:position => 12, :teams_champions_cup => 1).save
    CountryCoefQualyfication.new(:position => 13, :teams_champions_cup => 1).save
    CountryCoefQualyfication.new(:position => 14, :teams_champions_cup => 1).save
    CountryCoefQualyfication.new(:position => 15, :teams_champions_cup => 1).save
    CountryCoefQualyfication.new(:position => 16, :teams_champions_cup => 1).save
    CountryCoefQualyfication.new(:position => 17, :teams_champions_cup => 1).save
    CountryCoefQualyfication.new(:position => 18, :teams_champions_cup => 1).save
    CountryCoefQualyfication.new(:position => 19, :teams_champions_cup => 1).save
    CountryCoefQualyfication.new(:position => 20, :teams_champions_cup => 1).save
  end
end
