local playerPed = 0
local playerVehicle = 0
local vehicleAllowed = false
local vehControlEnabled = false
local isPadShaking = false

Citizen.CreateThread(function()

    while (true) do

        if (vehicleAllowed) then

            if not (vehControlEnabled) then

                if (GetEntitySpeed(playerVehicle) > 30.0) then

                    if (GetVehicleSteeringAngle(playerVehicle) > 30.0) or (GetVehicleSteeringAngle(playerVehicle) < -30.0) then

                        if (math.random(0, config.steeringChance) == 0) then
                            TriggerEvent('VehicleControlLoss', playerVehicle)
                        end

                    end

                end

            else

                if (IsControlPressed(0, 72)) or (IsControlPressed(0, 76)) then
                    ShakePad()
                end

            end

        end

        Citizen.Wait(0)

    end

end)

Citizen.CreateThread(function()

    while (true) do

        playerPed = PlayerPedId()
        playerVehicle = GetVehiclePedIsIn(playerPed, false)

        if (IsWeatherAccurate(GetNextWeatherTypeHashName())) then

            if (playerVehicle ~= 0) and (GetPedInVehicleSeat(playerVehicle, -1) == playerPed) then

                if not (IsClassDisabled(playerVehicle)) and not (IsVehicleDisabled(playerVehicle)) then

                    if not (vehicleAllowed) then
                        vehicleAllowed = true
                    end

                    if not (vehControlEnabled) then

                        if (GetEntitySpeed(playerVehicle) > 20.0) then

                            if (math.random(0, config.randomChance) == 0) then
                                
                                TriggerEvent('VehicleControlLoss', playerVehicle)
                            end
            
                        end

                    end

                else

                    if (vehicleAllowed) then
                        vehicleAllowed = false
                    end

                end

            else

                if (vehicleAllowed) then
                    vehicleAllowed = false
                end

            end

        else

            if (vehicleAllowed) then
                vehicleAllowed = false
            end

        end

        Citizen.Wait(1000)

    end

end)

function IsWeatherAccurate(weather)

    local accurateWeather = {
        1840358669, -- Clearing
        1420204096, -- Rain
        -1233681761, -- Thunder
        -1429616491, -- Xmas
        603685163, -- Light Snow
        -273223690, -- Snow
        669657108 -- Blizzard
    }

    for i,var in pairs(accurateWeather) do

        if (var == weather) then
            return true
        end

    end

    return false

end

function IsClassDisabled(vehicle)

    local vehClass = GetVehicleClass(vehicle)
    local disabledClasses = {
        10, -- Industrial
        13, -- Cycles
        14, -- Boats
        15, -- Helicopters
        16, -- Planes
        19, -- Military
        21 -- Trains
    }

    for i,var in pairs(disabledClasses) do

        if (var == vehClass) then
            return true
        end

    end

    return false

end

function IsVehicleDisabled(vehicle)

    for i,var in pairs(config.disabledVehicles) do

        if (GetHashKey(var) == GetEntityModel(vehicle)) then
            return true
        end

    end

    return false

end

function ShakePad()

    if not (isPadShaking) then

        isPadShaking = true

        local shakeDuration = math.random(1, 2) * 100

        StopPadShake(0)
        SetPadShake(0, shakeDuration, 255)

        Wait(shakeDuration + 100)

        isPadShaking = false

    end

end

RegisterNetEvent('VehicleControlLoss')
AddEventHandler('VehicleControlLoss', function(vehicle)

    vehControlEnabled = true
    SetVehicleReduceGrip(vehicle, true)

    Wait(math.random(1, 8) * 1000)

    SetVehicleReduceGrip(vehicle, false)
    vehControlEnabled = false

end)

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
local time = 5 -- how long the particle lasts
local SIZE = 1.0
local particleDict = "core"
local particleName = "ent_amb_generator_smoke"
local bone = "engine"
local car_net = nil
local table = table
local plantingTargetOffset = vector3(0,2,-3)
local plantingSpaceAbove = vector3(0,0,5.0)
local rayFlagsLocation = 17
local rayFlagsObstruction = 273
local particle = nil

local ongrass = false
function getPlantingLocation(visible)

    -- TODO: Refactor this *monster*, plx!
    local ped = PlayerPedId()



    local playerCoord = GetEntityCoords(ped)
    local target = GetOffsetFromEntityInWorldCoords(ped, plantingTargetOffset)
    local testRay = StartShapeTestRay(playerCoord, target, rayFlagsLocation, ped, 7) -- This 7 is entirely cargo cult. No idea what it does.
    local _, hit, hitLocation, surfaceNormal, material, _ = GetShapeTestResultEx(testRay)

    if hit == 1 then
        return material
    end

end


-- Citizen.CreateThread(function()
-- 	while true do
--         Wait(0)
--         if IsControlJustReleased(0, 18) then
--             print(getPlantingLocation(true))
--         end
        
-- 	end
-- end)


Citizen.CreateThread(function()
	while true do
        Wait(100)
        for k,v in ipairs(config.ground['grass']) do

            if getPlantingLocation(false) == v then 
                local vehicle = GetVehiclePedIsUsing(PlayerPedId())


                if GetVehicleClass(vehicle) == 0 then-- compats
                    if (GetEntitySpeed(vehicle) * 3.6 > 65.0) then
                        TriggerEvent('VehicleControlLoss', vehicle)

                    end


                elseif GetVehicleClass(vehicle) == 1 then --sendans

                    if (GetEntitySpeed(vehicle) * 3.6 > 65.0) then
                        TriggerEvent('VehicleControlLoss', vehicle)

                    end
                elseif GetVehicleClass(vehicle) == 2 then-- suvs
                    if (GetEntitySpeed(vehicle) * 3.6 > 80.0) then
                        print('es')
                        TriggerEvent('VehicleControlLoss', vehicle)

                    end

                elseif GetVehicleClass(vehicle) == 3 then-- Coupes

                    if (GetEntitySpeed(vehicle) * 3.6 > 65.0) then
                        TriggerEvent('VehicleControlLoss', vehicle)

                    end
                elseif GetVehicleClass(vehicle) == 4 then -- Muscle
                    if (GetEntitySpeed(vehicle) * 3.6 > 45.0) then
                        TriggerEvent('VehicleControlLoss', vehicle)

                    end

                elseif GetVehicleClass(vehicle) == 5 then-- Sports Classics
                    if (GetEntitySpeed(vehicle) * 3.6 > 25.0) then
                        TriggerEvent('VehicleControlLoss', vehicle)

                    end

                elseif GetVehicleClass(vehicle) == 6 then-- Sports
                    if (GetEntitySpeed(vehicle) * 3.6 > 25.0) then
                        TriggerEvent('VehicleControlLoss', vehicle)

                    end

                elseif GetVehicleClass(vehicle) == 7 then-- Super

                    if (GetEntitySpeed(vehicle) * 3.6 > 25.0) then
                        TriggerEvent('VehicleControlLoss', vehicle)

                    end
                elseif GetVehicleClass(vehicle) == 8 then-- Motorcycles
                    if (GetEntitySpeed(vehicle) * 3.6 > 75.0) then
                        TriggerEvent('VehicleControlLoss', vehicle)

                    end

                elseif GetVehicleClass(vehicle) == 9 then-- Off-road
                    if (GetEntitySpeed(vehicle) * 3.6 > 100.0) then
                        TriggerEvent('VehicleControlLoss', vehicle)

                    end

                elseif GetVehicleClass(vehicle) == 10 then-- Industrial
                    if (GetEntitySpeed(vehicle) * 3.6 > 30.0) then
                        TriggerEvent('VehicleControlLoss', vehicle)

                    end

                elseif GetVehicleClass(vehicle) == 11 then-- Utility 

                    if (GetEntitySpeed(vehicle) * 3.6 > 30.0) then
                        TriggerEvent('VehicleControlLoss', vehicle)

                    end
                elseif GetVehicleClass(vehicle) == 12 then-- Vans 
                    if (GetEntitySpeed(vehicle) * 3.6 > 45.0) then
                        TriggerEvent('VehicleControlLoss', vehicle)

                    end


                elseif GetVehicleClass(vehicle) == 17 then-- Service 
                    if (GetEntitySpeed(vehicle) * 3.6 > 65.0) then
                        TriggerEvent('VehicleControlLoss', vehicle)

                    end

                elseif GetVehicleClass(vehicle) == 18 then-- Emergency
                    if (GetEntitySpeed(vehicle) * 3.6 > 65.0) then
                        TriggerEvent('VehicleControlLoss', vehicle)

                    end

                elseif GetVehicleClass(vehicle) == 19 then-- Military 
                    if (GetEntitySpeed(vehicle) * 3.6 > 30.0) then
                        TriggerEvent('VehicleControlLoss', vehicle)

                    end

                elseif GetVehicleClass(vehicle) == 20 then-- Commercial 
                    if (GetEntitySpeed(vehicle) * 3.6 > 30.0) then
                        TriggerEvent('VehicleControlLoss', vehicle)

                    end

                end
            else
                ongrass = false
            end
        end
    end
end)




