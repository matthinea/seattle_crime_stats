class SeattleCrimeStats

  def self.get(params)

    precinct = params['precinct']
    beat = params['beat']

    from_date = flatten_date_array(params[:from_date])
    to_date = flatten_date_array(params[:to_date])

    from_date = convert_date(from_date)
    to_date = convert_date(to_date)

    client = SODA::Client.new({:domain => "data.seattle.gov", :app_token => ENV["X_APP_TOKEN"] })
    response = client.get("hapq-73pk.json", 
              {
                "$where" => "precinct = '#{precinct}' AND police_beat = '#{beat}' AND report_date > '#{from_date}' AND report_date < '#{to_date}'" 
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
    year = data[0]
    month = data[1]
    day = data[2]

    month = "0#{month}" if month < 10
    day = "0#{day}" if day < 10

    data = "#{year}-#{month}-#{day}T00:00:00.000"
  end

end

