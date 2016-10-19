class CreateRoutes < ActiveRecord::Migration[5.0]
  def change
    create_table :routes, id: false do |t|
      t.string :mta_id, null: false
      t.string :short_name
      t.string :long_name
      t.text :desc
      t.string :color
      t.string :text_color

      t.timestamps
    end
    add_index :routes, :mta_id, unique: true
  end
end
