class ChargingController < ApplicationController
before_action :authenticate_owner!
def show
    @profile = Backend.get_profile(DateTime.now, 1.hour.from_now, current_owner)
    @next_charge_time = charge_time(@profile[:charge_profile]) 
end


private
def charge_time(profile)
    chargeidx = profile.find_index{|item| item > 0}
    if(!chargeidx.nil?)
        return Time.now + chargeidx.hours
    end
    return nil;
end

end