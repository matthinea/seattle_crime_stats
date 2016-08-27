class Precinct < ActiveRecord::Base

  has_many :beats, foreign_key: :precinct_id


  def self.get_all_precinct_totals
    precincts = ["N", "W", "SE", "E", "SW"]
    all_precincts_totals = {}

    precincts.each do |precinct|
      precinct = Precinct.find_by_name(precinct)
      current_precinct_totals = Hash.new(0)

      current_precinct_totals = precinct.get_totals

      all_precincts_totals[precinct.name] = current_precinct_totals
    end

    all_precincts_totals
  end



  private




end
