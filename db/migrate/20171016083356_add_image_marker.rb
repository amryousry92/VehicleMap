class AddImageMarker < ActiveRecord::Migration
  def change
    change_table :locations do |t|
      t.string :picture
      t.string :title
    end
  end
end
