class Country < ActiveRecord::Base
  attr_accessible :shortcut, :image
  
  has_many :players
  has_many :teams
  has_many :leagues
  has_many :country_coefs
  
  def get_position
    coefs = CountryCoef.ordered_by_sum
    a = 1
    
    for c in coefs
      if c.country_id == id
        return a
      end
      a = a + 1
    end
    
    return nil
  end
  
  def get_qualyfication
    return CountryCoefQualyfication.by_pos(get_position)
  end
end
