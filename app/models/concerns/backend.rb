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
            uri = URI.parse('http://127.0.0.1:5000/api/GetChargingProfile')
            req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
            req.body = tocall.to_json
            res = Net::HTTP.start(uri.hostname, uri.port) do |http|
                http.request(req)
            end
            JSON.parse(res.body)
        end
        
        def self.call_backend_from_db
            # call = build_call
            reducedVehicleValues = Vehicle.last(5).inject ([]) {|seed, veh| seed.push veh.consumptions.first(5).map {|x| x.consumption.to_i}}
            vehiclevalues = Vehicle.second.consumptions.first(5).map {|x| x.consumption.to_i}
            tocall = {
                pricePredictions: PricePrediction.first(5).map {|x| x.price.round},
                demandPredictions: DemandPrediction.first(5).map {|x| x.value.round},
                maxVehicleChargingRates: [25, 25, 25, 25,25],
                maxVehicleDischargingRates: [2,2,2,2,2],
                maxVehicleChargeCapacities: [15,15,15,15,15],
                journeyInformation: reducedVehicleValues,
                initialVehicleCharge:reducedVehicleValues.map{|x| x.inject(0){|sum, x| sum + x} }
            }
            puts tocall
            uri = URI.parse('http://127.0.0.1:5000/api/GetChargingProfile')
            req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
            req.body = tocall.to_json
            puts req.body
            res = Net::HTTP.start(uri.hostname, uri.port) do |http|
                http.request(req)
            end
            newBody = JSON.parse(res.body)
            puts newBody
            newBody
        end


        def self.get_demand_from_api
            puts 'getting demand from API'
            uri = URI.parse('http://127.0.0.1:5000/api/GetDemandPredictions')
            req = Net::HTTP::Get.new(uri, 'Content-Type' => 'application/json')
            res = Net::HTTP.start(uri.hostname, uri.port) do |http|
                http.request(req)
            end
            newBody = JSON.parse(res.body)
            puts newBody
            File.open('demand.txt', 'w') { |file| file.write(newBody) }
            newBody
        end

    end