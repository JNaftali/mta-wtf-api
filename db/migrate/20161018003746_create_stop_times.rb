class CreateStopTimes < ActiveRecord::Migration[5.0]
  def change
    create_table :stop_times, id: false do |t|
      t.string :trip_id, foreign_key: true, null: false, index: true
      t.string :track_id, foreign_key: true, null: false, index: true
      t.time :arrival_time
      t.time :departure_time
      t.integer :stop_sequence

      t.timestamps
    end
  end
end
