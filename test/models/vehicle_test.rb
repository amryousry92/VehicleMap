require 'test_helper'

class VehicleTest < ActiveSupport::TestCase
  fixtures :vehicles

  def test_vehicle

     vehicle = Vehicle.new(uid:"abc123")

     assert vehicle.save

     vehicle_copy = Vehicle.find(vehicle.id)

     assert_equal vehicle.uid, vehicle_copy.uid


     assert vehicle.save
     assert vehicle.destroy
  end

end
