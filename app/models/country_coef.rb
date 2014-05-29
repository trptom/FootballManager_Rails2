class CountryCoef < ActiveRecord::Base
  attr_accessible :coef, :season, :country, :country_id
  
  belongs_to :country
  
  # By default returns countries ordered by coef for last COEF_COUNT_YEARS.
  # You can change this behavior by setting from and to params.
  scope :ordered_by_sum, ->(from = (Params.season-COEF_COUNT_YEARS), to = (Params.season-1)) {
    select("country_id, sum(coef) as coef")
        .where("(season >= ?)AND(season <= ?)", [from, 1].max, to)
        .group("country_id")
        .order("coef DESC")
  }
  
  scope :by_country_and_years, ->(country, from = (Params.season-COEF_COUNT_YEARS), to = (Params.season-1)) {
    where("(country_id = ?)AND(season >= ?)AND(season <= ?)", country.id, [from, 1].max, to)
        .order("season")
  }
  
  scope :at_position, ->(position, from = (Params.season-COEF_COUNT_YEARS), to = (Params.season-1)) {
    ordered_by_sum(from, to)[position]
  }
end
