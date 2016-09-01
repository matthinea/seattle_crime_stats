class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def all_beats_in_precinct_stringified(precinct)
    precinct.beats.map {|beat| beat.name}.join(", ")
  end

  def totals(data_points)
    stats = Hash.new(0) 
    data_points.each do |crime|
      type = crime['crime_type']
      count = crime['stat_value'].to_i
      stats[type] += count
    end
    stats
  end

end
