class CreateTrips < ActiveRecord::Migration[5.0]
  def change
    create_table :trips do |t|
      t.references :route, foreign_key: true
      t.string :mta_id
      t.integer :direction_id
      t.string :shape_id

      t.timestamps
    end
    add_index :trips, :mta_id, unique: true
  end
end
