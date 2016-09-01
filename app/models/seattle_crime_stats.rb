require 'data'

class SeattleCrimeStats

  PRECINCTS = Data.precincts_with_beats.keys.flatten
  BEATS = Data.precincts_with_beats.values.flatten

  def self.get(params)

    precinct = convert_precinct(params[:precinct])
    beat = convert_beat(params[:beat])

    from_date = convert_date(params[:from_date])
    to_date = convert_date(params[:to_date])

    client.get("hapq-73pk.json", 
              {
                "$where" => "precinct = '#{precinct}' AND police_beat = '#{beat}' AND report_date > '#{from_date}' AND report_date < '#{to_date}'" 
                })
  end

  def self.all_crimes_in_precinct_in_period(params)
    response = get_precinct_crimes(params)

    totals = Hash.new(0)

    response.each do |crime|
      type = crime['crime_type']
      count = crime['stat_value'].to_i
      totals[type] += count
    end

    totals
  end

  def self.get_beat_crimes(beat, from_date, to_date)
    from_date = convert_date(from_date)
    to_date = convert_date(to_date)
    client.get("hapq-73pk.json", 
              {
                "$where" => "police_beat = '#{beat}' AND report_date > '#{from_date}' AND report_date < '#{to_date}'" 
                })
  end

  def self.get_precinct_crimes(params)
    from_date = convert_date(params[:from_date])
    to_date = convert_date(params[:to_date])
    precinct = convert_precinct(params[:precinct])

    client.get("hapq-73pk.json", 
              {
                "$where" => "precinct = '#{precinct}' AND report_date > '#{from_date}' AND report_date < '#{to_date}'" 
                })
  end

  def self.totals(response)
    stats = Hash.new(0) 

    response.each do |crime|
      type = crime['crime_type']
      count = crime['stat_value'].to_i
      stats[type] += count
    end

    stats
  end

  def self.get_beat_totals(beat)
    client = SODA::Client.new({:domain => "data.seattle.gov", :app_token => ENV["X_APP_TOKEN"] })
    response = client.get("hapq-73pk.json", { "$where" => "police_beat = '#{beat}'"})
  end





  private 

  def self.flatten_date_array(hash)
    %w(1 2 3).map { |e| hash["date(#{e}i)"].to_i }
  end

  def self.convert_date(data)
    data = flatten_date_array(data)

    year = data[0]
    month = data[1]
    day = data[2]

    month = "0#{month}" if month < 10
    day = "0#{day}" if day < 10

    data = "#{year}-#{month}-#{day}T00:00:00.000"
  end

  def self.convert_precinct(precinct_num)
    precinct = PRECINCTS[precinct_num.to_i - 1]
  end

  def self.convert_beat(beat_num)
    beat = BEATS[beat_num.to_i - 1]
  end


  def self.client
    SODA::Client.new({:domain => "data.seattle.gov", :app_token => ENV["X_APP_TOKEN"] })
  end

end

