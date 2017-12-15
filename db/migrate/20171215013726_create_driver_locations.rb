class CreateDriverLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :driver_locations do |t|
      t.integer :driver_id
      t.integer :order_id
      t.string :service_type
      t.text :location
      t.decimal :lat
      t.decimal :lng
      t.string :status

      t.timestamps
    end
  end
end
