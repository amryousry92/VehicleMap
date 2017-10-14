class VehiclesController < ApplicationController

  def create
    vehicle = Vehicle.new
    vehicle.uid = params[:id]
    vehicle.save
    render :nothing => true, :status =>204
  end

  def destroy
    vehicle = Vehicle.where(uid: params[:id]).first
    vehicle.locations.destroy_all
    vehicle.destroy
    render nothing: true, :status =>204
  end

  def add_location
    location = Location.new
    vehicle=Vehicle.where(uid: params[:id]).first
    location.lat = params[:lat]
    location.lng = params[:lng]
    location.location_timestamp = DateTime.parse(params[:at])
    location.save
    render nothing: true, :status =>204
  end

  def show
    vehicle=Vehicle.where(uid: params[:id]).first
    render :json => {"vehicle"=>vehicle }
  end

  def main
    @locations = Location.all
    @hash = Gmaps4rails.build_markers(@locations) do |location, marker|
      marker.lat location.lat
      marker.lng location.lng
    end
  end

end
