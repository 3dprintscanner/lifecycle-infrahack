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
            File.open('request2.txt', 'w') { |file| file.write(tocall.to_json) }    

            res = Net::HTTP.start(uri.hostname, uri.port) do |http|
                http.request(req)
            end
            JSON.parse(res.body)
        end
        
        def self.call_backend_from_db
            # call = build_call
            # reducedVehicleValues = Vehicle.last(5).inject ([]) {|seed, veh| seed.push veh.consumptions.first(20).map {|x| 0}}
            # vehiclevalues = Vehicle.second.consumptions.last(5).map {|x| x.consumption.to_i}
            # tocall = {
            #     pricePredictions:  PricePrediction.first(20).map {|x| x.price.round},
            #     demandPredictions: DemandPrediction.first(20).map {|x| x.value.round},
            #     maxVehicleChargingRates: [25, 25, 25, 25,25],
            #     maxVehicleDischargingRates: [15,15,15,15,15],
            #     maxVehicleChargeCapacities: [15,15,15,15,15],
            #     journeyInformation: reducedVehicleValues,
            #     initialVehicleCharge: reducedVehicleValues.map{|x| x.inject(0){|sum, x| 12} }
            # }

            tocall = self.build_api_call(nil).first
            puts tocall
            uri = URI.parse('http://127.0.0.1:5000/api/GetChargingProfile')
            req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
            req.body = tocall.to_json
            # puts req.body
            # return
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
            # File.open('demand.txt', 'w') { |file| file.write(newBody) }
            newBody
        end

        def self.get_profile(start_time, end_time, current_owner)
            # let's make a call to the backend so we can fetch some charging data for a particular car
            tocall, index = self.build_api_call(current_owner)


            uri = URI.parse('http://127.0.0.1:5000/api/GetChargingProfile')
            req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
            req.body = tocall.to_json
            puts req.body
            newBody = nil
            begin
                res = Net::HTTP.start(uri.hostname, uri.port) do |http|
                    http.request(req)
                end
                newBody = JSON.parse(res.body)
            rescue StandardError => e
                # puts e
            end
            puts newBody
            owner_profile =  newBody['dumbChargingProfiles'][index]
            cost = newBody['smartCost']
            return {
                charge_profile: owner_profile,
                cost: cost
            }

        end

        def self.create_filled_series(consumptions, max_size)
            
            size_of = consumptions.length
            mapped = consumptions.map {|cons| cons.consumption}
            (max_size - size_of).times.each_with_index do |itm, idx|
                if(idx % 3 == 0)
                    mapped << 0
                else
                    mapped << rand(0..10)
                end
                
            end
            mapped
        end

        def self.build_api_call(current_owner)
            @stops = []
            @maxrates = []
            @maxDischargeRates = []
            @maxCapacities = []
            @initialCharges = []
            @current_owner_journey = nil
            @current_owner_journey_index = nil

            max_stops = 0
            total_consumptions = 0
            total_initial_charge = 0
            total_demand_prediction = 0

            area_ratio = 4

            max_stops = Journey.all.map {|x| x.consumptions.length}.max

            Journey.all.each_with_index do |journey,index|
            # Journey.select {|jny| jny.start_time >= start_time and jny.end_time <= end_time}.each_with_index do |journey,index|
                if(!current_owner.nil? and journey.owner == current_owner and @current_owner_journey.nil?)
                    @current_owner_journey = journey
                    @current_owner_journey_index = index
                end
                total_consumptions += journey.consumptions.sum {|x| x.consumption}
                total_initial_charge += journey.vehicle.initialcharge
                @stops << self.create_filled_series(journey.consumptions, max_stops)
                @maxrates << journey.vehicle.chargerate.to_i
                @maxCapacities << journey.vehicle.battery_capacity.to_i
                @maxDischargeRates << journey.vehicle.dischargerate.to_i
                # @initialCharges << journey.vehicle.current_charge.to_i
                @initialCharges << 5
            end
            total_demand_prediction = DemandPrediction.first(max_stops).inject(0) {|acc, x| acc + x.value}
            area_ratio = 4

            factor = (area_ratio * (total_consumptions - total_initial_charge)) / total_demand_prediction
            tocall = {
                pricePredictions:  PricePrediction.first(max_stops).map {|x| 1},
                demandPredictions: DemandPrediction.first(max_stops).map {|x| (x.value * factor).round},
                maxVehicleChargingRates: @maxrates,
                maxVehicleDischargingRates: @maxDischargeRates,
                maxVehicleChargeCapacities: @maxCapacities,
                journeyInformation: @stops,
                initialVehicleCharge: @initialCharges
            }

            File.open('jsonrequest.json', 'w') { |file| file.write(tocall.to_json) }


            return tocall, @current_owner_journey_index || 0
        end

    end