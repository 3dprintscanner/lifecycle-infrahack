require 'net/http'
require 'json'
module Backend
    extend ActiveSupport::Concern

        def self.call_backend
            # call = build_call
            tocall = {
                pricePredictions: [1,1,1,1,1],
                demandPredictions: [1,0,0,5,1],
                maxVehicleChargingRates: [25],
                maxVehicleDischargingRates: [2],
                maxVehicleChargeCapacities: [15],
                journeyInformation: [[0,1,6,5,7]],
                initialVehicleCharge:[8]
            }
            uri = URI.parse('http://6fb73074.ngrok.io/api/GetChargingProfile')
            req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
            req.body = tocall.to_json
            res = Net::HTTP.start(uri.hostname, uri.port) do |http|
                http.request(req)
            end
            JSON.parse(res.body)
        end
        
        def self.call_backend_from_db
            # call = build_call
            vehiclevalues = Vehicle.second.consumptions.first(5).map {|x| x.consumption.to_i}
            tocall = {
                pricePredictions: PricePrediction.first(5).map {|x| x.price.round},
                demandPredictions: DemandPrediction.first(5).map {|x| x.value.round},
                maxVehicleChargingRates: [25],
                maxVehicleDischargingRates: [2],
                maxVehicleChargeCapacities: [15],
                journeyInformation: [vehiclevalues],
                initialVehicleCharge:[vehiclevalues.inject(0){|sum,x| sum + x } +2]
            }
            uri = URI.parse('http://6fb73074.ngrok.io/api/GetChargingProfile')
            req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
            req.body = tocall.to_json
            puts req.body
            res = Net::HTTP.start(uri.hostname, uri.port) do |http|
                http.request(req)
            end
            JSON.parse(res.body)
        end


        # def build_call
        #     call = {'pricePredictions' => PricePrediction.all,
        #     'demandPredictions' => DemandPrediction.all,
        #     'maxVehicleChargingRates' => [1,3,4],
        #     'maxVehicleDischargingRates' => [2,3,4],
        #     'maxVehicleChargeCapacitites' => [64,32,53],
        #     'journeyInformation' => [[1,4,8],[2,4,5],[5,6,7]],
        #     'initialVehicleCharge'=> [5,6,7]
        #     }
        # end
    end