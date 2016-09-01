class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def all_beats_in_precinct_stringified(precinct)
    precinct.beats.map {|beat| beat.name}.join(", ")
  end

end
