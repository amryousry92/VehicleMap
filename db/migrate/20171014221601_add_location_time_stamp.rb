class AddLocationTimeStamp < ActiveRecord::Migration
  def change
    change_table :locations do |t|
      t.datetime :location_timestamp
    end
  end
end
