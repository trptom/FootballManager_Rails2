class CountryCoef < ActiveRecord::Base
  belongs_to :country
  attr_accessible :coef, :season
end
