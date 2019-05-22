
class API::V1::JourneyController < ActionController::API
    
    def create
        vehicle = Vehicle.find(journey_params[:vehicle_id])
        param_hash = params.to_unsafe_h.to_h

        @journey = Journey.new(journey_params)
        cons_arr = []
        consumptions =   param_hash['consumptions'].each do |x|
             consumption = Consumption.new(x)
             consumption.journey = @journey
             consumption.vehicle = vehicle
             consumption.save
             cons_arr.push(consumption)
             
        end
        @journey.consumptions = cons_arr
        @journey.owner = vehicle.owner
        if @journey.save
            return render :json => @journey
        end
        head 400
    end

    def journey_params
        params.require(:journey).permit(:time, :vehicle_id, {consumptions: :lat}, :origin, :destination, :originLat, :originLon, :destinationLat, :destinationLon)

    end

end