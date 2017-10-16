require 'test_helper'

class VehiclesControllerTest < ActionController::TestCase

  test "should create vehicle" do
    get(:create, {'param' => "value"}
    assert_response(204)
  end

  test "should destroy vehicle" do
    delete(:delete, {'param' => "value"}
    assert_response(204)
  end

  test "should get vehicle" do
    get(:show, {'param' => "value"}
    assert_response(204)
  end

  test "should add new location" do
      post :add_location, { 'param' => "value" }, :format => "json"
      assert_response(204)
  end

  

end
