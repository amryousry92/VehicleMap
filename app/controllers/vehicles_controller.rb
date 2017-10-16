class VehiclesController < ApplicationController

# Creates new vehicle record
  def create
    vehicle = Vehicle.new
    vehicle.uid = JSON.parse(params.keys[0])["id"]
    vehicle.save
    render :nothing => true, :status =>204
  end

# Deletes vehicle record from database
  def destroy
    vehicle = Vehicle.where(uid: params[:id]).first
    # vehicle.locations.destroy_all
    vehicle.destroy
    render nothing: true, :status =>204
  end

# Adding new location and checking whether it is within radius
  def add_location
    #To make sure that location is within 3.5 kilometers radius from door2door location
    body_params = JSON.parse(params.keys[0])
    if(body_params["lat"]<(D2DLOCATION[:lat] + RADIUS) && body_params["lat"]>(D2DLOCATION[:lat] - RADIUS) && body_params["lng"]>(D2DLOCATION[:lng] - RADIUS/Math.cos(body_params["lat"]).abs) && body_params["lng"]<(D2DLOCATION[:lng] + RADIUS/Math.cos(body_params["lat"]).abs) )
      vehicle=Vehicle.where(uid: params[:id]).first
      location = Location.new
      location.lat = body_params["lat"]
      location.lng = body_params["lng"]
      location.location_timestamp = DateTime.parse(body_params["at"])
      location.vehicle_id=vehicle.id
      location.title = params[:id]
      prev_locations = PrevHash.instance
      if(prev_locations.value(params[:id])!=[])
        prev_lat = prev_locations.value(params[:id]).split(",")[0].to_f
        prev_lng = prev_locations.value(params[:id]).split(",")[1].to_f
# => Check location relative to the previous location indicating direction
        if(location.lng-prev_lng<0)
          location.picture=DIRECTION[:left]
        elsif(location.lng-prev_lng>0)
          location.picture=DIRECTION[:right]
        elsif(location.lat-prev_lat<0)
          location.picture=DIRECTION[:down]
        elsif(location.lat-prev_lat>0)
          location.picture=DIRECTION[:up]
        end
      end
      prev_locations.add(params[:id],location.lat.to_s+","+location.lng.to_s)
      location.save
    end
    render nothing: true, :status =>204
  end
# Get vehicle by uid
  def show
    vehicle=Vehicle.where(uid: params[:id]).first
    render :json => {"vehicle"=>vehicle }
  end
# initialize door2door initial marker
  def main
    @d2d_location=[]
    @d2d_location.push(D2DLOCATION)
  end

# poll database to get vehicles locations
  def polling
    @locations = Location.where("picture IS NOT NULL").group('vehicle_id').order('location_timestamp desc')
    render :json => {"vehicles"=>@locations }
  end
end
