require 'test_helper'

class LocationTest < ActiveSupport::TestCase

  def test_location

     location = Location.new(lat: 11.3,lng:13.0,vehicle_id:1, location_timestamp: DateTime.parse('2017-12-02T12:00:00+01:00'),picture:"/assert/right.png",title:"abc")

     assert location.save

     location_copy = Location.find(location.id)

     assert_equal location.title, location_copy.title

     assert location.save
     assert location.destroy
  end

end
