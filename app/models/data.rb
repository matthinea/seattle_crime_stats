class Data

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