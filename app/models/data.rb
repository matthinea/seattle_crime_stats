class Data

  # # for determining whether beat(s) experienced higher or lower
  # CITYWIDE_DATASET_TOTALS = {
    # "Homicide"=>141, 
    # "Rape"=>610, 
    # "Robbery"=>9554, 
    # "Assault"=>12287, 
    # "Larceny-Theft"=>137660, 
    # "Motor Vehicle Theft"=>23052, 
    # "Burglary"=>42270
  # }

  # NUM_MONTHS_IN_DATASET = 71

  # CITYWIDE_MONTHLY_AVGS_BY_TYPE = {}

  # CITYWIDE_DATASET_TOTALS.each do |type, num_crimes| 
  #   CITYWIDE_MONTHLY_AVGS_BY_TYPE[type] = num_crimes / NUM_MONTHS_IN_DATASET
  # end

  def self.totals(data_points)
    stats = Hash.new(0) 
    data_points.each do |crime|
      type = crime['crime_type']
      count = crime['stat_value'].to_i
      stats[type] += count
    end
    stats
  end

  def self.precincts_with_beats
    n = ["B", "J", "N", "L", "U"]
    w = ["Q", "D", "M", "K"]
    se = ["S", "O", "R"]
    e = ["C", "E", "G"]
    sw = ["W", "F"]
    beat_prefixes = [n, w, se, e, sw]
    
    precincts = ["N", "W", "SE", "E", "SW"]

    iteratively_set_precincts_and_beats(precincts, beat_prefixes)
  end

  def self.iteratively_set_precincts_and_beats(precincts, beat_prefixes)
    out = Hash.new([])

    precincts.each_with_index do |precinct, idx|
      precinct_beats = []
      beat_prefixes[idx].each do |beat_prefix|
        sector_beats = []
        3.times do |x|

          sector_beats << "#{beat_prefix}#{x + 1}"

        end
        precinct_beats << sector_beats
      end
      out[precinct] = precinct_beats.flatten
    end
    out
  end

end