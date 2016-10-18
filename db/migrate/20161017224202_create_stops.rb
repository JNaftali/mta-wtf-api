class CreateStops < ActiveRecord::Migration[5.0]
  def change
    create_table :stops do |t|
      t.string :mta_id
      t.string :name
      t.float :lat
      t.float :lon
      t.integer :parent_station_id, optional: true, foreign_key: true

      t.timestamps
    end
    add_index :stops, :mta_id, unique: true
  end
end
