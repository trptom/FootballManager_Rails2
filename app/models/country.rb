class Country < ActiveRecord::Base
  attr_accessible :shortcut, :image
  
  has_many :players
  has_many :teams
  has_many :leagues
end
