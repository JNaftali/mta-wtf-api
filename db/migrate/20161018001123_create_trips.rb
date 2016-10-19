class CreateTrips < ActiveRecord::Migration[5.0]
  def change
    create_table :trips, id: false do |t|
      t.string :mta_id, null: false
      t.string :route_id, foreign_key: true
      t.integer :direction_id
      t.string :shape_id

      t.timestamps
    end
    add_index :trips, :mta_id, unique: true
  end
end
