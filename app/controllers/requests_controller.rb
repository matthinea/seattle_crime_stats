class RequestsController < ApplicationController

  def index
    set_index_instance_variables
  end

  def show
    @precinct = Precinct.find_by_id(params[:precinct])

    city_crimes
    from_date = convert_date(params[:from_date])
    to_date = convert_date(params[:to_date])

    # validate user input
    if from_date > to_date
      flash[:danger] = "Please select a valid date range."
      redirect_to root_path
      return
    elsif !params[:beat].empty? && !@precinct.beats.include?(Beat.find(params[:beat]))
      flash[:danger] = "Please choose a valid police precinct and beat."
      redirect_to root_path
      return
    end

    if params[:beat].empty?
      @beat_name = all_beats_in_precinct_stringified(@precinct)
      @precinct_totals_data = SeattleCrimeStats.all_crimes_in_precinct_in_period(whitelisted_params)
      @precinct_totals = totals(@precinct_totals_data)
      @totals = @precinct_totals
    else
      beat = Beat.find_by_id(params[:beat])
      @stats = SeattleCrimeStats.beat_crimes(whitelisted_params)
      @totals = totals(@stats)
      @precinct_totals_data = SeattleCrimeStats.all_crimes_in_precinct_in_period(whitelisted_params)
      @precinct_totals = totals(@precinct_totals_data)
      @beat_name = beat.name
    end

    @precinct_options = Precinct.all.map{ |p| [p.name, p.id] }
    @beat_options = Beat.all.map{ |b| [b.name, b.id] }
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

  def convert_date(date)
    SeattleCrimeStats.convert_date(date)
  end

  def city_crimes
    data = SeattleCrimeStats.all_crimes_in_city_in_period(whitelisted_params)
    @city_crimes = totals(data)
  end

end



