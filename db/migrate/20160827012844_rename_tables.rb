class RenameTables < ActiveRecord::Migration
  def change
    rename_table :precinct_data, :precincts
    rename_table :beat_data, :beats
  end
end
