local QBCore = exports['qb-core']:GetCoreObject()

-- Apanhar Plantas
RegisterServerEvent('mt-weed:server:Apanhar', function() 
    local src = source
    local Player  = QBCore.Functions.GetPlayer(src)
    local quantity = math.random(2, 6)
	if (70 >= math.random(1, 100)) then
        if Player.Functions.AddItem("weed_og-kush_crop", quantity) then   
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["weed_og-kush_crop"], 'add', quantity)
        else
            TriggerClientEvent('okokNotify:Alert', source, "FARMING", "POCKETS FULL!", 2000, 'error')
        end		
	else
        if Player.Functions.AddItem("weed_og-kush_seed", 1) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["weed_og-kush_seed"], 'add', 1)
         else
            TriggerClientEvent('okokNotify:Alert', source, "FARMING", "POCKETS FULL!", 2000, 'error')
        end		
    end
end)

-- Cortar plantas de weed em sacos
RegisterServerEvent('mt-weed:server:CortarWeed', function(args) 
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local args = tonumber(args)
    local removeAmount = 1
    local returnAmount = math.random (20,28)
	local returnAmount2 = math.random (30,50)
    local baggieAmount = 28
	local baggieAmount2 = 50
    local packageTime = 7500
    if args == 1 then 
        local cocaine = Player.Functions.GetItemByName("weed_og-kush_crop") 
        if cocaine ~= nil then
            if cocaine.amount >= removeAmount then
                local baggies = Player.Functions.GetItemByName("empty_weed_bag") 
                if baggies ~= nil then
                    if baggies.amount >= baggieAmount then
                        Player.Functions.RemoveItem("weed_og-kush_crop", removeAmount)
						Player.Functions.RemoveItem("empty_weed_bag", returnAmount)
                        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['weed_og-kush_crop'], "remove", removeAmount)
						TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['empty_weed_bag'], "remove", returnAmount)
                        TriggerClientEvent('pogressBar:drawBar', src, packageTime, 'Trimming Buds')
                        SetTimeout(packageTime, function()
                            if Player.Functions.AddItem('weed_og-kush_crop', returnAmount, nil, info, {["quality"] = 100}) then
                                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["weed_og-kush_crop"], "add", returnAmount)
								TriggerClientEvent('QBCore:Notify', src, 'You cut a weed plant!', 'success')
                                TriggerClientEvent('mt-weed:client:MenuCorte', src)
                            else
                                TriggerClientEvent('QBCore:Notify', src, 'Pockets Full!', 'error')
                            end
                        end)
                    else
                        TriggerClientEvent('QBCore:Notify', src, "You need more bags!", 'error')
                        TriggerClientEvent('mt-weed:client:MenuCorte', src)
                    end
                else
                    TriggerClientEvent('QBCore:Notify', src, "You need more bags!", "error")
                    TriggerClientEvent('mt-weed:client:MenuCorte', src)
                end
            else
                TriggerClientEvent('QBCore:Notify', src, "You need weed plants!", 'error')
                TriggerClientEvent('mt-weed:client:MenuCorte', src)
            end
        else
            TriggerClientEvent('QBCore:Notify', src, "You need weed plants!", "error")
            TriggerClientEvent('mt-weed:client:MenuCorte', src)
        end
    end
end)

-- Usar kit de corte
QBCore.Functions.CreateUseableItem("drug_cuttingkit", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    local scaleCheck = Player.Functions.GetItemByName('drug_scales')
    if scaleCheck ~= nil then
        TriggerClientEvent('mt-weed:client:MenuCorte', source)
    else
        TriggerClientEvent('QBCore:Notify', source, "NEED SCALE", 'error')
    end
end)
