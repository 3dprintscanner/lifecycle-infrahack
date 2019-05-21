class JourneysController < InheritedResources::Base

  def new
    @journey = Journey.new
  end


  private

    def journey_params
      params.require(:journey).permit(:owner_id, :vehicle_id, :origin, :destination)
    end
end

