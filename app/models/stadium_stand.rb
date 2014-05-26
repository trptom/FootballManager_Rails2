class StadiumStand < ActiveRecord::Base
  belongs_to :stadium
  attr_accessible :angle, :capacity, :rows, :level, :location, :maintenance, :type
end
