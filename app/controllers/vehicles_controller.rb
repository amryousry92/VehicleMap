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
    # where_statement = "(lat between "+(@d2d_location.lat - 0.032).to_s+" and "+(@d2d_location.lat + 0.032).to_s+") AND (lng between "+(@d2d_location.lng - 0.032).to_s+" and "+(@d2d_location.lng + 0.032).to_s+")"
    #To make sure that location is within 3.5 kilometers radius from door2door location
    body_params = JSON.parse(params.keys[0])
    if(body_params["lat"]<(D2DLOCATION[:lat] + 0.032) && body_params["lat"]>(D2DLOCATION[:lat] -0.032) && body_params["lng"]>(D2DLOCATION[:lng] - 0.032/Math.cos(body_params["lat"]).abs) && body_params["lng"]<(D2DLOCATION[:lng] + 0.032/Math.cos(body_params["lat"]).abs) )
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
        if(location.lng-prev_lng<0)
          location.picture='/assets/left.png'
        elsif(location.lng-prev_lng>0)
          location.picture='/assets/right.png'
        elsif(location.lat-prev_lat<0)
          location.picture='/assets/down.png'
        elsif(location.lat-prev_lat>0)
          location.picture='/assets/up.png'
        end
      end
      prev_locations.add(params[:id],location.lat.to_s+","+location.lng.to_s)
      location.save
    end
    render nothing: true, :status =>204
  end

  def show
    vehicle=Vehicle.where(uid: params[:id]).first
    render :json => {"vehicle"=>vehicle }
  end

  def main
    @d2d_location=[]
    @d2d_location.push(D2DLOCATION)
    @locations = Location.where("picture IS NOT NULL").group('vehicle_id').order('location_timestamp desc').group('vehicle_id')
    puts @locations.first.inspect
  end

  def polling
    main()
    render :json => {"vehicles"=>@locations }
  end
end
