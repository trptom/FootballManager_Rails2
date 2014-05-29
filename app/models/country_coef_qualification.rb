class CountryCoefQualification < ActiveRecord::Base
  attr_accessible :position, :teams_champions_cup
  
  def self.by_pos(position)
    return where(:position => position).first
  end
end
