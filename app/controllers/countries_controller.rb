class CountriesController < ApplicationController
  def coefficients
    # for first season, I dont have any previous data so i order just by current
    # season results
    if Params.season == 1
      @coefs = CountryCoef.ordered_by_sum(1, 1)
    else
      @coefs = CountryCoef.ordered_by_sum
    end
  end
  
  def show
    @country = Country.find(params[:id])
  end
end
