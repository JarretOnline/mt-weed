local QBCore = exports['qb-core']:GetCoreObject()
local spawnedPlants = 0
local weedPlants = {}

-- Criar blip para a apanha de weed

--[[
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(-2198.48, 5123.81, 12.42) -- Mudar coordenadas do blip aqui!
	SetBlipSprite(blip, 140) -- Mudar estilo do blip aqui!
	SetBlipDisplay(blip, 2)
	SetBlipScale(blip, 0.7)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 3)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Weed Picking") -- Mudar nome do Blip aqui!
    EndTextCommandSetBlipName(blip)
end)
]]--

-- Apanhar Plantas
RegisterNetEvent('mt-weed:client:Apanhar', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local nearbyObject, nearbyID
	for i=1, #weedPlants, 1 do
		if GetDistanceBetweenCoords(coords, GetEntityCoords(weedPlants[i]), false) < 4.0 then
			nearbyObject, nearbyID = weedPlants[i], i
		end
	end
	QBCore.Functions.TriggerCallback('QBCore:HasItem', function(HasItem)
		if HasItem then
			if nearbyObject and IsPedOnFoot(playerPed) then
				isPickingUp = true
				exports['ps-ui']:Circle(function(success)
					if success then
						exports["mz-skills"]:UpdateSkill("FARMING", 1) ---skills add xp
						exports['okokNotify']:Alert("SKILLS", "[XP] +1 ", 2000, 'success')
							ExecuteCommand( "e garden" )
							Wait(math.random(4000,8000))
							TriggerServerEvent('mt-weed:server:Apanhar')
							ExecuteCommand( "e c" )
							ExecuteCommand( "pf" )
							ClearPedTasks(playerPed)
							DeleteObject(nearbyObject) 

                        -----ADDING SKILL REWARDS
                        exports["mz-skills"]:CheckSkill("FARMING", 25, function(hasskill)
							if hasskill then
								exports['okokNotify']:Alert("SKILLS", "EXTRA LOOT!", 2000, 'success')
								TriggerServerEvent('mt-weed:server:Apanhar')
							else
							end
							end)
	
							exports["mz-skills"]:CheckSkill("FARMING", 50, function(hasskill)
							if hasskill then
								exports['okokNotify']:Alert("SKILLS", "EXTRA LOOT!", 2000, 'success')
								TriggerServerEvent('mt-weed:server:Apanhar')
							else
							end
							end)
	
							exports["mz-skills"]:CheckSkill("FARMING", 100, function(hasskill)
							if hasskill then
								exports['okokNotify']:Alert("SKILLS", "EXTRA LOOT!", 2000, 'success')
								TriggerServerEvent('mt-weed:server:Apanhar')
							else
							end
							end)
	
							exports["mz-skills"]:CheckSkill("FARMING", 200, function(hasskill)
							if hasskill then
								exports['okokNotify']:Alert("SKILLS", "EXTRA LOOT!", 2000, 'success')
								TriggerServerEvent('mt-weed:server:Apanhar')
							else
							end
							end)
	
							exports["mz-skills"]:CheckSkill("FARMING", 400, function(hasskill)
							if hasskill then
								exports['okokNotify']:Alert("SKILLS", "EXTRA LOOT!", 2000, 'success')
								TriggerServerEvent('mt-weed:server:Apanhar')
							else
							end
							end)
	
							exports["mz-skills"]:CheckSkill("FARMING", 600, function(hasskill)
							if hasskill then
								exports['okokNotify']:Alert("SKILLS", "EXTRA LOOT!", 2000, 'success')
								TriggerServerEvent('mt-weed:server:Apanhar')
							else
							end
							end)
	
							exports["mz-skills"]:CheckSkill("FARMING", 800, function(hasskill)
							if hasskill then
								exports['okokNotify']:Alert("SKILLS", "EXTRA LOOT!", 2000, 'success')
								TriggerServerEvent('mt-weed:server:Apanhar')
							else
							end
							end)
	
							exports["mz-skills"]:CheckSkill("FARMING", 1000, function(hasskill)
							if hasskill then
								exports['okokNotify']:Alert("SKILLS", "EXTRA LOOT!", 2000, 'success')
								TriggerServerEvent('mt-weed:server:Apanhar')
							else
							end
							end)
							-----ENDING SKILL REWARDS
							
					else
						exports["mz-skills"]:UpdateSkill("FARMING", -2) ---skills remove xp
						exports['okokNotify']:Alert("SKILLS", "[XP] -2 ", 2000, 'error')
					end
				end, math.random(4,8), math.random(8,16)) -- NumberOfCircles, MS
			end
		else
			exports['okokNotify']:Alert("FARMING", "MISSING: SHOVEL!", 2000, 'error')
		end
	end, "trowel")
end)

-- Pegar Coordenadas
CreateThread(function()
	while true do
		Wait(10)
		local coords = GetEntityCoords(PlayerPedId())
		if GetDistanceBetweenCoords(coords, Config.WeedField, true) < 100 then
			SpawnweedPlants()
			Wait(500)
		else
			Wait(500)
		end
	end
end)

-- Eliminar Plantas ao Apanhar
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(weedPlants) do
			DeleteObject(v)
		end
	end
end)

-- Spawn Plantas
function SpawnObject(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(1)
	end
    local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)
    SetModelAsNoLongerNeeded(model)
    PlaceObjectOnGroundProperly(obj)
    FreezeEntityPosition(obj, true)
    if cb then
        cb(obj)
    end
end

-- Gerar Coordenadas para as Plantas
function SpawnweedPlants()
	while spawnedPlants < 30 do
		Wait(1)
		local plantCoords = GeneratePlantsCoords()
		SpawnObject('prop_weed_01', plantCoords, function(obj)
			table.insert(weedPlants, obj)
			spawnedPlants = spawnedPlants + 1
		end)
	end
end 

-- Validar Coordenadas
function ValidatePlantsCoord(plantCoord)
	if spawnedPlants > 0 then
		local validate = true
		for k, v in pairs(weedPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 4 then
				validate = false
			end
		end
		if GetDistanceBetweenCoords(plantCoord, Config.WeedField, false) > 100 then
			validate = false
		end
		return validate
	else
		return true
	end
end

-- Gerar Box Coords
function GeneratePlantsCoords()
	while true do
		Wait(1)
		local weedCoordX, weedCoordY
		math.randomseed(GetGameTimer())
		local modX = math.random(-12, 12)
		Wait(100)
		math.randomseed(GetGameTimer())
		local modY = math.random(-1, 2)
		weedCoordX = Config.WeedField.x + modX
		weedCoordY = Config.WeedField.y + modY
		local coordZ = GetCoordZPlants(weedCoordX, weedCoordY)
		local coord = vector3(weedCoordX, weedCoordY, coordZ)
		if ValidatePlantsCoord(coord) then
			return coord
		end
	end
end

-- Verificar Altura das Coordenadas
function GetCoordZPlants(x, y)
	local groundCheckHeights = { 35, 36.0, 37.0, 38.0, 39.0, 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0, 50.0, 51.0, 52.0, 53.0, 54.0, 55.0 }
	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)
		if foundGround then
			return z
		end
	end
	return 53.85
end

--Target para apanha
exports['qb-target']:AddTargetModel(`prop_weed_01`, {
    options = {
        {
            event = "mt-weed:client:Apanhar",
            icon = "fas fa-seedling",
            label = "TAKE",
        },
    },
    distance = 4.0
})

RegisterNetEvent('mt-weed:client:pararMenuCorte', function()
    ClearPedTasks(PlayerPedId())
end)

-- Menu de corte
RegisterNetEvent('mt-weed:client:MenuCorte', function()
    TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_PARKING_METER", 3500, false)
    exports['qb-menu']:openMenu({
        {
            header = "Harvest Weed",
            txt = "10x Drug Bags</p>1x Weed",
            isMenuHeader = true
        },
        {
            header = "Trim Plant",
            txt = "",
            params = {
                event = "mt-weed:server:CortarWeed",
                isServer = true,
                args = 1

            }
        },
        {
            header = "❌ Close",
            params = {
                event = "mt-weed:client:pararMenuCorte"
            }
        },
    })
end)
