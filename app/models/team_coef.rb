class TeamCoef < ActiveRecord::Base
  attr_accessible :coef, :season
  
  belongs_to :team
end
