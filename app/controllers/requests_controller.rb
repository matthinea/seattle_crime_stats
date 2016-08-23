class RequestsController < ApplicationController

  ENDPOINT = "https://data.seattle.gov/resource/hapq-73pk.json"

  GRAND_TOTALS = {
    "Homicide"=>145, 
    "Rape"=>620, 
    "Robbery"=>9656, 
    "Assault"=>12415, 
    "Larceny-Theft"=>139264, 
    "Motor Vehicle Theft"=>23391, 
    "Burglary"=>42795
  }

  def index

  end

  def show
    @stats = SeattleCrimeStats.get(whitelisted_params)
    @totals = SeattleCrimeStats.totals(@stats)
    @precinct_totals = PrecinctDatum.find_by_name(params[:precinct]).get_totals
  end

  def whitelisted_params
    params.permit(:precinct, :beat, {:from_date => :date, :to_date => :date})
  end

end



