class Beat < ActiveRecord::Base

  belongs_to :precinct, foreign_key: :precinct_id

end
