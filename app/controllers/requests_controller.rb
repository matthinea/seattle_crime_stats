class RequestsController < ApplicationController

  def index
    set_index_instance_variables
  end

  def show
    @precinct = Precinct.find_by_id(params[:precinct])

    city_crimes
    from_and_to_dates(whitelisted_params)

    unless @from_date < @to_date
      flash[:danger] = "Please select a valid date range."
      redirect_to root_path
      return
    end

    if params[:beat].empty?
      @beat_name = all_beats_in_precinct_stringified(@precinct)
      @precinct_totals = SeattleCrimeStats.all_crimes_in_precinct_in_period(whitelisted_params)
      @totals = @precinct_totals
    else
      beat = Beat.find_by_id(params[:beat])
      if @precinct.beats.include?(beat)
        stats = SeattleCrimeStats.get(whitelisted_params)
        @totals = SeattleCrimeStats.totals(stats)
        @precinct_totals = SeattleCrimeStats.all_crimes_in_precinct_in_period(whitelisted_params)
        @beat_name = beat.name
      else
        flash[:danger] = "Please choose a valid police precinct and beat."
        redirect_to root_path
      end
    end

  end


  private

  def whitelisted_params
    params.permit(:precinct, :beat, {:from_date => :date, :to_date => :date})
  end

  def set_index_instance_variables
    @precinct_options = Precinct.all.map{ |p| [p.name, p.id] }
    @beat_options = Beat.all.map{ |b| [b.name, b.id] }
    @precinct = Precinct.new
    @beat = Beat.new
  end

  def from_and_to_dates(params)
    @from_date = SeattleCrimeStats.convert_date(params[:from_date])
    @to_date = SeattleCrimeStats.convert_date(params[:to_date])    
  end

  def city_crimes
    data = SeattleCrimeStats.all_crimes_in_city_in_period(whitelisted_params)
    @city_crimes = SeattleCrimeStats.totals(data)
  end

end



