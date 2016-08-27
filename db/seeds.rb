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