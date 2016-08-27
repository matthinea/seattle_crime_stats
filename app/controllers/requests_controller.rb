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
    @precinct_options = Precinct.all.map{ |p| [p.name, p.id] }
    @beat_options = Beat.all.map{ |b| [b.name, b.id] }
    @precinct = Precinct.new
    @beat = Beat.new
  end

  def show
    @stats = SeattleCrimeStats.get(whitelisted_params)
    @totals = SeattleCrimeStats.totals(@stats)
    precinct = Precinct.find_by_id(params[:precinct])
    @precinct_totals = SeattleCrimeStats.get_time_period_totals(whitelisted_params)
  end

  def whitelisted_params
    params.permit(:precinct, :beat, {:from_date => :date, :to_date => :date})
  end

end



