
class API::V1::JourneyController < ActionController::API
    
    def create
        @journey = Journey.new(journey_params)
        if @consumption.save
            return render :json => @consumption
        end
        head 400
    end

    def journey_params
        params.permit(:time, :consumption, :vehicle_id, :consumptions)
    end

end