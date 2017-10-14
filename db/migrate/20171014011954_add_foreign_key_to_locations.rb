class AddForeignKeyToLocations < ActiveRecord::Migration
  def change
    change_table :locations do |t|
      t.integer :vehicle_id
    end
  end
end
