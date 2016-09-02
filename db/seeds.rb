# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'data'

precinct_beats = Data.precincts_with_beats

precinct_beats.each do |precinct, beats| 
  precinct = Precinct.create(name: precinct)
  beats.each do |beat|
    new_beat = Beat.create(:name => beat)
    precinct.beats << new_beat
    precinct.save
  end
end

# store total # of each crime type in beat attributes


Beat.all.each do |beat|
  beat_totals_data = SeattleCrimeStats.beat_totals(beat.name)
  beat_totals = Data.totals(beat_totals_data)
  
  beat.homicides = beat_totals["Homicide"]
  beat.rapes = beat_totals["Rape"]
  beat.robberies = beat_totals["Robbery"]
  beat.assaults = beat_totals["Assault"]
  beat.larceny_thefts = beat_totals["Larceny-Theft"]
  beat.motor_vehicle_thefts = beat_totals["Motor Vehicle Theft"]
  beat.burglaries = beat_totals["Burglary"]
  beat.save!
end