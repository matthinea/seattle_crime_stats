class CreateBeatData < ActiveRecord::Migration
  def change
    create_table :beat_data do |t|
      t.string :name
      t.integer :precinct_id
      
      t.integer :homicides
      t.integer :rapes
      t.integer :robberies
      t.integer :assaults
      t.integer :larceny_thefts
      t.integer :motor_vehicle_thefts
      t.integer :burglaries

      t.timestamps null: false
    end
  end
end
