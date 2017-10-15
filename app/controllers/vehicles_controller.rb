class VehiclesController < ApplicationController

  def create
    vehicle = Vehicle.new
    vehicle.uid = JSON.parse(params.keys[0])["id"]
    vehicle.save
    render :nothing => true, :status =>204
  end

  def destroy
    vehicle = Vehicle.where(uid: params[:id]).first
    # vehicle.locations.destroy_all
    vehicle.destroy
    render nothing: true, :status =>204
  end

  def add_location
    location = Location.new
    vehicle=Vehicle.where(uid: params[:id]).first
    body_params = JSON.parse(params.keys[0])
    location.lat = body_params["lat"]
    location.lng = body_params["lng"]
    location.location_timestamp = DateTime.parse(body_params["at"])
    location.vehicle_id=vehicle.id
    location.save
    render nothing: true, :status =>204
  end

  def show
    vehicle=Vehicle.where(uid: params[:id]).first
    render :json => {"vehicle"=>vehicle }
  end

  def main
    @locations = Location.all.group('vehicle_id').order('location_timestamp desc').group('vehicle_id')
    @hash = Gmaps4rails.build_markers(@locations) do |location, marker|
      marker.lat location.lat
      marker.lng location.lng
    end
    @d2d_location = Vehicle.where(uid: "d2d").first.locations.first
  end

  def polling
    main()
    puts @locations.inspect
    render :json => {"vehicles"=>@locations }
  end
end
