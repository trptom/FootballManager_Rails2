class CountriesController < ApplicationController
  def coefficients
    @coefs = CountryCoef.ordered_by_sum(Params.season-5, Params.season-1)
  end
  
  def show
    @country = Country.find(params[:id])
  end
end
