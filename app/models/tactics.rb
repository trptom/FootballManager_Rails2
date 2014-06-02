include TacticsHelper

class Tactics < ActiveRecord::Base
  attr_accessible :id, :aggressiveness, :name, :passing, :priority, :shooting, :style,
    :team, :team_id
  
  belongs_to :team
  has_many :tactics_players, dependent: :destroy
  
  after_create do |record|
    TacticsHelper::fill_squad(record)
  end
  
  scope :by_priority, -> {
    order("priority DESC, name")
  }
end
