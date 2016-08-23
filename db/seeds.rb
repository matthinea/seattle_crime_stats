# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


beats =[ "W3", "R3", "B2", "G2", "S1", "E2", "J2", "M3", "C2", "W1", "Q2", "O1", "L3", "U1", "Q1", "N3", "F1", "B3", "S2", "N1", "C1", "G1", "K2", "M2", "L2", "M1", "D3", "K3", "F3", "J3", "O3", "U2", "Q3", "G3", "K1", "E1", "S3", "D1", "F2", "U3", "R1", "D2", "O2", "E3", "W2", "C3", "L1", "N2", "R2", "J1", "B1"]


precincts = ["N", "W", "SE", "E", "SW"]

precincts.each {|precinct| PrecinctDatum.create(name: precinct) }


