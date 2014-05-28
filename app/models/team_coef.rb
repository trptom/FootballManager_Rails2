class TeamCoef < ActiveRecord::Base
  belongs_to :team
  attr_accessible :coef, :season
end
