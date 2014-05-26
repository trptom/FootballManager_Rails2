class Stadium < ActiveRecord::Base
  attr_accessible :name, :team, :team_id
  
  belongs_to :team
  has_many :stadium_stands
end
