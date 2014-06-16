class CreateCountryCoefQualifications < ActiveRecord::Migration
  def self.up
    create_table :country_coef_qualifications do |t|
      t.integer :position,              :null => false, :unique => true
      t.integer :teams_champions_cup,   :null => false, :default => 0

      t.timestamps
    end
    
    CountryCoefQualification.new(:position => 1, :teams_champions_cup => 4).save
    CountryCoefQualification.new(:position => 2, :teams_champions_cup => 4).save
    CountryCoefQualification.new(:position => 3, :teams_champions_cup => 3).save
    CountryCoefQualification.new(:position => 4, :teams_champions_cup => 3).save
    CountryCoefQualification.new(:position => 5, :teams_champions_cup => 3).save
    CountryCoefQualification.new(:position => 6, :teams_champions_cup => 3).save
    CountryCoefQualification.new(:position => 7, :teams_champions_cup => 2).save
    CountryCoefQualification.new(:position => 8, :teams_champions_cup => 2).save
    CountryCoefQualification.new(:position => 9, :teams_champions_cup => 2).save
    CountryCoefQualification.new(:position => 10, :teams_champions_cup => 2).save
    CountryCoefQualification.new(:position => 11, :teams_champions_cup => 1).save
    CountryCoefQualification.new(:position => 12, :teams_champions_cup => 1).save
    CountryCoefQualification.new(:position => 13, :teams_champions_cup => 1).save
    CountryCoefQualification.new(:position => 14, :teams_champions_cup => 1).save
    CountryCoefQualification.new(:position => 15, :teams_champions_cup => 1).save
    CountryCoefQualification.new(:position => 16, :teams_champions_cup => 1).save
    CountryCoefQualification.new(:position => 17, :teams_champions_cup => 1).save
    CountryCoefQualification.new(:position => 18, :teams_champions_cup => 1).save
    CountryCoefQualification.new(:position => 19, :teams_champions_cup => 1).save
    CountryCoefQualification.new(:position => 20, :teams_champions_cup => 1).save
  end
  
  def self.down
    drop_table :country_coef_qualifications
  end
end
