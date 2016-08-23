class BeatDatum < ActiveRecord::Base

  belongs_to :precinct_datum, foreign_key: :precinct_id

end
