class PrecinctDatum < ActiveRecord::Base

  has_many :beat_data, foreign_key: :precinct_id

  def get_totals
    client = SODA::Client.new({:domain => "data.seattle.gov", :app_token => ENV["X_APP_TOKEN"] })
    response = client.get("hapq-73pk.json", { "$where" => "precinct = '#{self.name}'"})

    totals = Hash.new(0)

    response.each do |crime|
      type = crime['crime_type']
      count = crime['stat_value'].to_i
      totals[type] += count
    end

    totals
  end

  def self.get_all_precinct_totals
    precincts = ["N", "W", "SE", "E", "SW"]
    all_precincts_totals = {}

    precincts.each do |precinct|
      precinct = PrecinctDatum.find_by_name(precinct)
      current_precinct_totals = Hash.new(0)

      current_precinct_totals = precinct.get_totals

      all_precincts_totals[precinct.name] = current_precinct_totals
    end

    all_precincts_totals
  end



end
