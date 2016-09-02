class RequestsController < ApplicationController

  def index
    set_index_instance_variables
  end

  def show
    @precinct = Precinct.find_by_id(params[:precinct])

    city_crimes
    

    # validate user input
    from_date = convert_date(params[:from_date])
    to_date = convert_date(params[:to_date])
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
      @all_beats = true
      # to get average rates, take all crime / 71
      # compare it to @avg_crimes_per_month_by_type
      @beat_name = all_beats_in_precinct_stringified(@precinct)
      @precinct_totals_data = SeattleCrimeStats.all_crimes_in_precinct_in_period(whitelisted_params)
      @precinct_totals = Data.totals(@precinct_totals_data)
      @totals = @precinct_totals
      @all_crimes_in_dataset_in_area = Data.totals(SeattleCrimeStats.collect_data_where("precinct = '#{@precinct.name}'"))
    else
      beat = Beat.find_by_id(params[:beat])
      @stats = SeattleCrimeStats.beat_crimes(whitelisted_params)
      @totals = Data.totals(@stats)
      @precinct_totals_data = SeattleCrimeStats.all_crimes_in_precinct_in_period(whitelisted_params)
      @precinct_totals = Data.totals(@precinct_totals_data)
      @beat_name = beat.name
      @all_crimes_in_dataset_in_area = Data.totals(SeattleCrimeStats.collect_data_where("police_beat = '#{beat.name}'"))
    end

    date1 = Date.parse(@precinct_totals_data[0].report_date)
    date2 = Date.parse(@precinct_totals_data[-1].report_date)
    @num_months = (date2.year * 12 + date2.month) - (date1.year * 12 + date1.month)

    # reset form options
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
    @city_crimes = Data.totals(data)
  end


  # (newsum - oldsum) / oldsum

  # def avg_crimes_per_month_by_type(totals, num_months)
  #   avg_totals = {}
  #   totals.each {|type, num| avg_totals[type] = num / num_months }
  #   avg_totals
  # end

end



