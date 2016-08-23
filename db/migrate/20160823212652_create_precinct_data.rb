class CreatePrecinctData < ActiveRecord::Migration
  def change
    create_table :precinct_data do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
