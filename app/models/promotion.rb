class Promotion < ActiveRecord::Base
  attr_accessible :barage, :league_from_id, :league_from_pos, :league_to_id, :league_to_pos
  
  belongs_to :league_from, :class_name => "League"
  belongs_to :league_to, :class_name => "League"
end
